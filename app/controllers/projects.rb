# -*- encoding: utf-8; mode: ruby; tab-width: 2; indent-tabs-mode: nil -*-
require "app/models/project"
require "app/models/user"
require "app/models/build"

class Projects < SimpleCI::Base
  disable :authorization

  helpers do
    def status_class(status)
      case status
      when true
        "alert-success"
      when false
        "alert-danger"
      else
        "alert-warning"
      end
    end
    
    def status_name(status)
      case status
      when true
        "passed"
      when false
        "failed"
      else
        "in progress"
      end
    end
  end

  before do
    @builds ||= []
    @project_users ||= []
  end

  before "/:project_name/?*" do |project_name, _|
    unless project_name == "new"
      @project_name = project_name
      @project = @remote_user.admin ? Project.find_by_name(project_name) : @remote_user.projects.find_by_name(project_name)
      forbidden! unless @project
      @builds = @project.builds.order("updated_at ASC")
      @current_build = @builds.last
    end
  end

  # Show list of projects

  get "/?" do
    @projects = @remote_user.admin ? Project.all : @remote_user.projects
    erb :projects_list
  end

  # Create new Project

  get "/new" do
    require_authorization!
    @project = Project.new
    @users = User.all
    erb :projects_form
  end

  get "/:project_name/settings" do |project_name|
    require_authorization!
    @users = User.all
    @project_users = []; @project.users.each { |u| @project_users << u.id }
    erb :projects_form
  end

  get "/:project_name/build/:id" do |project_name,id|
    @current_build = @project.builds.find_by_id(id)
    erb :projects_details
  end

  get "/:project_name/?" do |project_name|
    erb :projects_details
  end

  # curl --user "admin@domain.tld:abcd1234" --data "foo=bar" http://localhost:8080/projects/keystore/build
  post "/:project_name/build" do |project_name|
    fire_and_forget do
      # TODO: Ugly-ass hack to be replaced by something better
      $simpleci_base_url = "#{request.env["rack.url_scheme"]}://#{request.env["SERVER_NAME"]}#{ ":" + request.env["SERVER_PORT"] unless request.env["SERVER_PORT"].match(/^(80|443)$/)}"
      Build.build!(@project)
    end
    [202]
  end

  post "/:project_name" do |project_name|
    require_authorization!
    users = @body_params.delete("users") || {}
    
    if @project.update_attributes(@body_params)
      @project.users = [*User.find(users.keys)]
      redirect to("/#{@project.name}")
    else
      @errors = @project.errors.messages
      erb :projects_form
    end
  end

  post "/?" do
    require_authorization!
    users = @body_params.delete("users") || {}
    @project = Project.create(@body_params)

    if (@errors = @project.errors.messages).empty? 
      @project.users = [*User.find(users.keys)]
      redirect to("/#{@project.name}")
    else
      @users = User.all
      erb :projects_form
    end
  end

end
