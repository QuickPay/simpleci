# -*- encoding: utf-8; mode: ruby; tab-width: 2; indent-tabs-mode: nil -*-
require "test/unit"
require "test/helper"
require "rack/test"

class TestBuild < Test::Unit::TestCase
  include SimpleCI::Test::Methods
  include Rack::Test::Methods
  
  def test_git
    post("/projects/foo/build", {}, basic_auth_header("user1"))
    assert_equal(last_response.status, 202)
    
    sleep 1
    
    get("/projects/foo", {}, basic_auth_header("user1"))
    assert(last_response.body.match(/This is supposed to simulate a test failure as the exit status will be 1/))
  end

  def test_hg
    post("/projects/bar/build", {}, basic_auth_header("user2"))
    assert_equal(last_response.status, 202)
    
    sleep 1

    get("/projects/bar", {}, basic_auth_header("user2"))
    assert(last_response.body.match(/This is supposed to simulate a test passed as the exit status will be 0/))
  end

end
