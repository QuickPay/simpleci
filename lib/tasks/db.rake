# -*- encoding: utf-8; mode: ruby; tab-width: 2; indent-tabs-mode: nil -*-
require "./config/environment"
require "active_record"

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

  desc "Reset database"
  task :reset do
    begin
      re = ""
      while not re =~ /(n|y)/
        puts "@@@ Warning @@@"
        puts "You are about to destroy data(!) - Do you want to continue? [y/n]"
        re = STDIN.gets.chomp
        if re == "y"
          con = ActiveRecord::Base.retrieve_connection
          tables = con.tables
          tables.delete("schema_migrations")
          tables.each do |t|
            con.execute("DROP TABLE IF EXISTS #{t} CASCADE")
          end
          con.execute("TRUNCATE schema_migrations")
          ActiveRecord::Migrator.migrate('migrate')
          puts "Done!"
        end
      end
    rescue Exception => e
      puts e.message
    end
  end
  
end
