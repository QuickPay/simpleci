# -*- encoding: utf-8; mode: ruby; tab-width: 2; indent-tabs-mode: nil -*-
require "logger"
require "sinatra/base"

module SimpleCI
  class Base < Sinatra::Base
    attr_reader :body_params, :query_params
    
    register SimpleCI::Auth

    set :root, APP_ROOT
    set :views, "app/views"

    configure do
      disable :show_exceptions
      enable  :dump_errors, :logging
    end

    configure :development do
      ActiveRecord::Base.logger = ::Logger.new(File.open("log/database.log", 'w+'))
    end

    before do
      # Separate out params that sinatra will otherwise merge together
      @body_params   = request.env["rack.request.form_hash"] || {} # request.env["rack.input"] || {} # See Rack::Utils.parse_query && Rack::Request.body
      @query_params  = request.env["rack.request.query_hash"] || {}
      # Verify connection and reconnect if lost
      ActiveRecord::Base.connection.verify!
    end

    helpers do
      # Run block of code in a seperate process
      def fire_and_forget &block
        raise ::LocalJumpError, "No block given" unless block_given?
        Process.detach(fork &block)
      end
    end

  end
end
