# -*- encoding: utf-8; mode: ruby; tab-width: 2; indent-tabs-mode: nil -*-
require "lib/simpleci"
require "app/models/project"
require "app/models/user"

class Users < SimpleCI::Base

  helpers do
    def e(name, out = nil)
      err = @errors[name.to_sym] and @errors[name.to_sym].join(", ")
      (out ? out % err : err) if err
    end
  end

  before do
    @errors ||= {}
    @user_projects ||= []
  end

  before "/:id/?*" do |user_id, _|
    unless user_id == "new"
      @user = User.find_by_id(user_id)
      halt 404, "Not Found" unless @user
      @projects = Project.all
      @user.projects.each { |p| @user_projects << p.id }
    end
  end

  get "/new" do
    @user = User.new
    @projects = Project.all
    erb :users_form
  end

  get "/:id" do |id|
    erb :users_form
  end

  get "/?" do
    @users = User.all
    erb :users_list
  end

  post "/:id" do |id|
    projects = @body_params.delete("projects") || {}
    @body_params["admin"] ||= false

    @body_params.delete("password") if @body_params["password"].blank?
    @body_params.delete("password_confirmation") if @body_params["password_confirmation"].blank?
    
    if @user.update_attributes(@body_params)
      @user.projects = [*Project.find(projects.keys)]
      redirect to("/")
    else
      @errors = @user.errors.messages
      erb :users_form
    end
  end

  post "/?" do
    projects = @body_params.delete("projects") || {}
    @body_params["admin"] ||= false
    @user = User.create(@body_params)

    if (@errors = @user.errors.messages).empty?
      @user.projects = [*Project.find(projects.keys)]
      redirect to("/#{@user.id}")
    else
      #@user = User.new
      @projects = Project.all
      erb :users_form
    end
  end

end
