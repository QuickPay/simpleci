# -*- encoding: utf-8; mode: ruby; tab-width: 2; indent-tabs-mode: nil -*-
require 'sinatra/extension'
require "app/models/user"

module SimpleCI
  module Auth
    attr_reader :remote_user
    extend Sinatra::Extension

    configure do
      # these can be disabled in the controllers
      set :authentication, true
      set :authorization, true
    end

    helpers do
      def bad_request!
        throw :halt, [ 400, 'Bad Request' ]
      end

      def unauthenticated!
        response['WWW-Authenticate'] = %(Basic)
        throw :halt, [ 401, 'Authentication Required' ]
      end

      def forbidden!
        throw :halt, [ 403, 'Forbidden' ]
      end
      
      def require_authorization!
        forbidden! unless @remote_user.admin
      end
    end

    before do

      # Handle authentication
      if settings.authentication?

        auth = Rack::Auth::Basic::Request.new(request.env)
        unauthenticated!  unless auth.provided?
        bad_request!      unless auth.basic?
        unauthenticated!  if auth.credentials.nil? or auth.credentials.empty?
        unauthenticated!  unless @remote_user = User.authenticate(*auth.credentials)
        request.env['REMOTE_USER'] = auth.username if auth

        # Handle authorization
        require_authorization! if settings.authorization?
        
      end
    end
  end
end
