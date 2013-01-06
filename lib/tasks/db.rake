# -*- encoding: utf-8; mode: ruby; tab-width: 2; indent-tabs-mode: nil -*-
namespace :db do

  desc "Migrate database to different version (Target specific version with VERSION=x)"
  task :migrate => :environment do
    ActiveRecord::Migrator.migrate("db/migrate", ENV["VERSION"] ? ENV["VERSION"].to_i : nil )
  end
  
  namespace :schema do
    
    desc "Dump database schema to db/schema.rb"
    task :dump => :environment do
      schema = "db/schema.rb"
      FileUtils.touch(schema)
      # As schema is dumped to stdout, catch the content from there
      $stdout.reopen(schema)
      ActiveRecord::SchemaDumper.dump
    end    

    desc "Load database schema from db/schema.rb"
    task :load => :environment do
      schema = "db/schema.rb"
      load schema if FileTest.exist?(schema)
    end
  
  end

  desc "Reset database"
  task :reset => :environment do
    begin
      re = ENV['RACK_ENV'] == "test" ? "y" : "";
      while not re =~ /(n|y)/
        puts "@@@ Warning @@@"
        puts "You are about to destroy data(!) - Do you want to continue? [y/n]"
        re = STDIN.gets.chomp
      end
      if re == "y"
        con = ActiveRecord::Base.retrieve_connection
        tables = con.tables
        tables.delete("schema_migrations")
        tables.each do |t|
          con.execute("DROP TABLE IF EXISTS #{t} CASCADE")
        end
        con.execute("TRUNCATE schema_migrations")
        Rake::Task['db:migrate'].execute
      end
    rescue Exception => e
      puts e.message
    end
  end

  desc "Load test data into database"
  task :testdata => :environment do
    begin
      re = ENV['RACK_ENV'] == "test" ? "y" : "";
      while not re =~ /(n|y)/
        puts "@@@ Warning @@@"
        puts "You are about to import test data(!) - Do you want to continue? [y/n]"
        re = STDIN.gets.chomp
      end
      if re == "y"
        require "test/mock/data"
        Mock::Data.import
      end
    rescue Exception => e
      puts e.message
    end
  end
  
end
