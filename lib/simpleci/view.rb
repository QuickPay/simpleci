# -*- encoding: utf-8; mode: ruby; tab-width: 2; indent-tabs-mode: nil -*-
require 'sinatra/extension'
require 'cgi'
require 'uri'

module SimpleCI
  module View
    extend Sinatra::Extension

    helpers do
      def h(s)
        s.class == String ? CGI.escape_html(s) : s
      end
      def u(s)
        s.class == String ? URI.encode(s) : s
      end
      def uh(s)
        s.class == String ? CGI.escape_html(URI.encode(s)) : s
      end
    end

  end
end
