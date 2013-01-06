# -*- encoding: utf-8; mode: ruby; tab-width: 2; indent-tabs-mode: nil -*-
require "app/models/user"
require "app/models/project"
require "archive/zip"
require "digest/md5"
require "fileutils"

module Mock
  class Data
    def self.import
      git_repo = "#{APP_ROOT}/tmp/foo.git"
      hg_repo  = "#{APP_ROOT}/tmp/bar.hg"

      FileUtils.rm_rf([git_repo,hg_repo])

      Archive::Zip.extract("#{APP_ROOT}/test/mock/foo.git.zip", File.dirname(git_repo))
      Archive::Zip.extract("#{APP_ROOT}/test/mock/bar.hg.zip", File.dirname(hg_repo))

      u1 = User.new({ :email => "user1@domain.tld", :password => "abcd1234", :password_confirmation => "abcd1234" }); u1.save
      u2 = User.new({ :email => "user2@domain.tld", :password => "abcd1234", :password_confirmation => "abcd1234" }); u2.save

      p1 = Project.new({ :name => "foo", :path => "git://#{git_repo}", :command => "ruby test.rb"}); p1.save
      p2 = Project.new({ :name => "bar", :path => "hg://#{hg_repo}", :branch => "default", :command => "ruby test.rb"}); p2.save

      u1.projects = [p1]; u1.save
      u2.projects = [p2]; u2.save
      
      puts "Import of mock Data done!\n\n"
    end
  end
end