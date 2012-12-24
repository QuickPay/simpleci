# -*- encoding: utf-8; mode: ruby; tab-width: 2; indent-tabs-mode: nil -*-
namespace :db do

  desc "Migrate database to different version (Target specific version with VERSION=x)"
  task :migrate do
    ActiveRecord::Migrator.migrate("db/migrate", ENV["VERSION"] ? ENV["VERSION"].to_i : nil )
  end
  
  namespace :schema do
    
    desc "Dump database schema to db/schema.rb"
    task :dump do
      schema = "db/schema.rb"
      FileUtils.touch(schema)
      # As schema is dumped to stdout, catch the content from there
      $stdout.reopen(schema)
      ActiveRecord::SchemaDumper.dump
    end    

    desc "Load database schema from db/schema.rb"
    task :load do
      schema = "db/schema.rb"
      load schema if FileTest.exist?(schema)
    end
  
  end
  
end