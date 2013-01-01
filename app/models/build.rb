# -*- encoding: utf-8; mode: ruby; tab-width: 2; indent-tabs-mode: nil -*-
require "net/https"
require "app/models/project"
require "git"
require "mercurial-ruby"


class Build < ActiveRecord::Base
  belongs_to :project

  def self.build!(project)
    b = Build.create({ :project_id => project.id, :status => false })
    _, method, url = project.path.match(/^(git|hg):\/\/(.+)/).to_a
    
    begin 
      version, message, author = self.send(method, url, project.branch, b.id)
      b.update_attributes({:commit_version => version, :commit_message => message, :commit_author => author})
      output = Bundler.with_clean_env do
        "Running command: #{project.command}\n\n" + `cd #{APP_ROOT}/tmp/#{b.id} && #{project.command} 2>&1`
      end
      b.update_attributes({:output => output, :status => $?.success?})
    rescue Exception => e
      b.update_attributes({:output => e.message, :status => false})
      raise e
    ensure
      FileUtils.rm_rf("#{APP_ROOT}/tmp/#{b.id}")
    end

    unless project.hook.to_s.empty?
      hook_data = {
        :status => b.status,
        :built_at => b.updated_at,
        :project => project.name,
        :url => "#{$simpleci_base_url}/projects/#{project.name}",
        :commit_version => b.commit_version,
        :commit_author => b.commit_author,
        :commit_message => b.commit_message
      }

      uri = URI.parse(project.hook)
      
      http = Net::HTTP.new(uri.host, uri.port)
      if uri.scheme == "https"
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end

      post = Net::HTTP::Post.new(uri.request_uri)
      post['Content-Type'] = 'application/json'
      post.set_form_data({ "payload" => hook_data.to_json(:root => false) })

      res = http.request(post)
    end

    b
  end

  private

  def self.git(url, branch, id, commit = "HEAD")
    g = Git.clone(url, "#{APP_ROOT}/tmp/#{id}")
    g.branch("origin/#{branch}").checkout
    g.reset_hard(commit)
    c = g.gcommit(commit)

    [c.sha, c.message, c.author.name]
  end

  def self.hg(url, branch, id, commit = "HEAD")
    url = "file://#{url}" if url.match(/^\//)
    m = Mercurial::Repository.clone(url, "#{APP_ROOT}/tmp/#{id}", {})
    c = m.commits.by_branch(branch).first

    [c.hash_id, c.message, c.author]
  end

end
