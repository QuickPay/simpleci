# -*- encoding: utf-8; mode: ruby; tab-width: 2; indent-tabs-mode: nil -*-
require "active_record"
require "digest/md5"
require "app/models/user"
require "app/models/project"
require "app/models/build"
class MockData
  def self.import
    msg = <<MSG
Running command: bundle --path vendor/bundle --without mysql && RACK_ENV=test DATABASE_URL=sqlite3:///tmp/simpleci.db bundle exec rake test

Fetching gem metadata from https://rubygems.org/..........
Fetching gem metadata from https://rubygems.org/..
Installing rake (10.0.3) 
Installing i18n (0.6.1) 
Installing multi_json (1.5.0) 
Installing activesupport (3.2.9) 
Installing builder (3.0.4) 
Installing activemodel (3.2.9) 
Installing arel (3.0.2) 
Installing tzinfo (0.3.35) 
Installing activerecord (3.2.9) 
Installing backports (2.6.5) 
Installing eventmachine (1.0.0) with native extensions 
Installing foreigner (1.2.1) 
Installing git (1.2.5) 
Installing kgio (2.7.4) with native extensions 
Installing open4 (1.3.0) 
Installing mercurial-ruby (0.7.6) 
Installing pg (0.14.1) with native extensions 
Installing rack (1.4.1) 
Installing rack-protection (1.3.2) 
Installing rack-test (0.6.2) 
Installing racksh (1.0.0) 
Installing raindrops (0.10.0) with native extensions 
Installing shotgun (0.9) 
Installing tilt (1.3.3) 
Installing sinatra (1.3.3) 
Installing sinatra-contrib (1.3.2) 
Installing sqlite3 (1.3.6) with native extensions 
Installing unicorn (4.5.0) with native extensions 
Using bundler (1.2.3) 
Your bundle is complete! It was installed into ./vendor/bundle
Run options: 

# Running tests:

....

Finished tests in 1.280438s, 3.1239 tests/s, 9.3718 assertions/s.

4 tests, 12 assertions, 0 failures, 0 errors, 0 skips
MSG

    u1 = User.new({ :email => "demo1@domain.tld", :password => "abcd1234", :password_confirmation => "abcd1234" }); u1.save
    u2 = User.new({ :email => "demo2@domain.tld", :password => "abcd1234", :password_confirmation => "abcd1234" }); u2.save

    p1 = Project.new({ :name => "foo", :path => "git:///git/projects/foo", :command => "bundle && bundle exec rake test"}); p1.save
    p2 = Project.new({ :name => "bar", :path => "git:///git/projects/bar", :command => "bundle && bundle exec rake test"}); p2.save
    p3 = Project.new({ :name => "baz", :path => "git:///git/projects/baz", :command => "bundle && bundle exec rake test"}); p3.save

    u1.projects = [p1,p2,p3]; u1.save
    u2.projects = [p1,p3]; u2.save

    b11 = Build.new({ :project_id => p1.id, :status => true, :output => msg.chop.chomp, :commit_version => Digest::MD5.hexdigest([*0..9].sample(5).join("")).slice(0,8), :commit_message => "Fixed regression", :commit_author => "Demo 1" }); b11.save
    b12 = Build.new({ :project_id => p1.id, :status => false, :output => msg.chop.chomp, :commit_version => Digest::MD5.hexdigest([*0..9].sample(5).join("")).slice(0,8), :commit_message => "Fixed regression", :commit_author => "Demo 1" }); b12.save
    b13 = Build.new({ :project_id => p1.id, :status => true, :output => msg.chop.chomp, :commit_version => Digest::MD5.hexdigest([*0..9].sample(5).join("")).slice(0,8), :commit_message => "Fixed regression", :commit_author => "Demo 1" }); b13.save
    b14 = Build.new({ :project_id => p1.id, :status => true, :output => msg.chop.chomp, :commit_version => Digest::MD5.hexdigest([*0..9].sample(5).join("")).slice(0,8), :commit_message => "Fixed regression", :commit_author => "Demo 1" }); b14.save
    b21 = Build.new({ :project_id => p2.id, :status => false, :output => msg.chop.chomp, :commit_version => Digest::MD5.hexdigest([*0..9].sample(5).join("")).slice(0,8), :commit_message => "Fixed regression", :commit_author => "Demo 1" }); b21.save
    b22 = Build.new({ :project_id => p2.id, :status => true, :output => msg.chop.chomp, :commit_version => Digest::MD5.hexdigest([*0..9].sample(5).join("")).slice(0,8), :commit_message => "Fixed regression", :commit_author => "Demo 1" }); b22.save
    b23 = Build.new({ :project_id => p2.id, :status => false, :output => msg.chop.chomp, :commit_version => Digest::MD5.hexdigest([*0..9].sample(5).join("")).slice(0,8), :commit_message => "Fixed regression", :commit_author => "Demo 1" }); b23.save
  end
end