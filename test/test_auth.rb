# -*- encoding: utf-8; mode: ruby; tab-width: 2; indent-tabs-mode: nil -*-
require "test/unit"
require "test/helper"
require "rack/test"

class TestAuth < Test::Unit::TestCase
  include SimpleCI::Test::Methods
  include Rack::Test::Methods
  
  def test_authentication
    get("/projects")
    assert_equal(last_response.status, 401)

    get("/projects", {}, basic_auth_header("admin"))
    assert_equal(last_response.status, 200)
  end

  def test_authorization
    get("/users")
    assert_equal(last_response.status, 401)

    get("/users", {}, basic_auth_header("user1"))
    assert_equal(last_response.status, 403)

    get("/users", {}, basic_auth_header("admin"))
    assert_equal(last_response.status, 200)
  end

  def test_acl
    get("/projects/foo", {}, basic_auth_header("user1"))
    assert_equal(last_response.status, 200)

    get("/projects/bar", {}, basic_auth_header("user1"))
    assert_equal(last_response.status, 403)

    get("/projects/foo", {}, basic_auth_header("user2"))
    assert_equal(last_response.status, 403)

    get("/projects/bar", {}, basic_auth_header("user2"))
    assert_equal(last_response.status, 200)
  end

end
