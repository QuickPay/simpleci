# -*- encoding: utf-8; mode: ruby; tab-width: 2; indent-tabs-mode: nil -*-
require "rake/testtask"

desc "Run tests"
task :test => [:environment, 'db:reset', 'db:testdata'] do
  Rake::TestTask.new do |t|
    t.libs << "."
    t.test_files = Dir.glob("test/test_*.rb")
  end  
end
