# -*- encoding: utf-8; mode: ruby; tab-width: 2; indent-tabs-mode: nil -*-
require "base64"
require "test/unit"
require "rack/test"

class TestAuth < Test::Unit::TestCase
  include Rack::Test::Methods
  
  def app
    eval "Rack::Builder.new {( " + File.read(File.dirname(__FILE__) + '/../config.ru') + "\n )}.to_app"
  end

  def basic_auth_header(user)
    case user
    when "admin"
      { "HTTP_AUTHORIZATION" => "Basic #{Base64.encode64("admin@domain.tld:abcd1234")}" }
    when "demo1"
      { "HTTP_AUTHORIZATION" => "Basic #{Base64.encode64("demo1@domain.tld:abcd1234")}" }
    when "demo2"
      { "HTTP_AUTHORIZATION" => "Basic #{Base64.encode64("demo2@domain.tld:abcd1234")}" }
    end
  end

  def test_authentication
    get("/projects")
    assert_equal(last_response.status, 401)

    get("/projects", {}, basic_auth_header("admin"))
    assert_equal(last_response.status, 200)
  end

  def test_authorization
    get("/users")
    assert_equal(last_response.status, 401)

    get("/users", {}, basic_auth_header("demo1"))
    assert_equal(last_response.status, 403)

    get("/users", {}, basic_auth_header("admin"))
    assert_equal(last_response.status, 200)
  end

end