# -*- encoding: utf-8; mode: ruby; tab-width: 2; indent-tabs-mode: nil -*-
require "./config/environment"

require "app/controllers/users"
map "/users" do
  run Users.new
end

require "app/controllers/projects"
map "/projects" do
  run Projects.new
end

map('/') do
  run Sinatra.new { get('/?') { redirect to("/projects") } }
end
