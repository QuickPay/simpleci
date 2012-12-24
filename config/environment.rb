# -*- encoding: utf-8; mode: ruby; tab-width: 2; indent-tabs-mode: nil -*-

# Set application root and loadpath
APP_ROOT = File.realdirpath(File.dirname(__FILE__) + '/../')
$LOAD_PATH.push(APP_ROOT)

# Load environment
require "rubygems"
require "bundler"
Bundler.setup(:default, ENV["RACK_ENV"])

# Set up ActiveRecord and connect to DB
require "active_record"
require "erb"
ActiveRecord::Base.record_timestamps = true
ActiveRecord::Base.timestamped_migrations = false
ActiveRecord::Base.default_timezone = :utc
ActiveRecord::Base.include_root_in_json = false
ActiveRecord::Base.establish_connection(YAML.load(ERB.new(File.read('config/database.yml')).result)[ENV["RACK_ENV"]])

require "foreigner"
Foreigner.load
