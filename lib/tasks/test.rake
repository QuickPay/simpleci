# -*- encoding: utf-8; mode: ruby; tab-width: 2; indent-tabs-mode: nil -*-
require "rake/testtask"

Rake::TestTask.new(:test) do |t|
  Rake::Task[:environment].execute
  Rake::Task['db:reset'].execute
  Rake::Task['db:testdata'].execute
  t.libs << "."
  t.test_files = Dir.glob("test/test_*.rb")
end
