# -*- encoding: utf-8; mode: ruby; tab-width: 2; indent-tabs-mode: nil -*-
source "https://rubygems.org"

gem "activerecord", :require => "active_record"
gem "foreigner"
gem "git"
gem "mercurial-ruby"
gem "rake"
gem "sinatra"
gem 'sinatra-contrib'
gem 'unicorn'

group :postgresql do
  gem "pg"
end

group :mysql do
  gem "mysql2"
end

group :test do
  gem "rack-test"
  gem "sqlite3"
end

group :development do
  gem "rack-test"
  gem "racksh"
  gem "shotgun"
  gem "sqlite3"
end