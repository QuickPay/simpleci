# -*- encoding: utf-8; mode: ruby; tab-width: 2; indent-tabs-mode: nil -*-
require "base64"

module SimpleCI
	module Test
    module Methods

      def app
        eval "Rack::Builder.new {( " + File.read(File.dirname(__FILE__) + '/../config.ru') + "\n )}.to_app"
      end

      def basic_auth_header(user)
        case user
        when "admin"
          { "HTTP_AUTHORIZATION" => "Basic #{Base64.encode64("admin@domain.tld:abcd1234")}" }
        when "user1"
          { "HTTP_AUTHORIZATION" => "Basic #{Base64.encode64("user1@domain.tld:abcd1234")}" }
        when "user2"
          { "HTTP_AUTHORIZATION" => "Basic #{Base64.encode64("user2@domain.tld:abcd1234")}" }
        end
      end

    end
  end
end