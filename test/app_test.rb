require 'test/unit'
require 'rack/test'

OUTER_APP = Rack::Builder.parse_file('config.ru').first

class TestApp < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    OUTER_APP
  end

  test "should return 200 for GET /bla" do
    get "/bla"
    assert last_response.ok?
  end

  test "should return content type json for GET /bla" do
    get "/bla"
    assert_equal last_response.headers['Content-Type'], "application/josn"
  end

  test "should return a json 1,2,3 for GET /bla" do
    get "/bla"
    assert_equal last_response.body, {"results"=> [1,2,3]}.to_json
  end

  test "should return 200 for POST /bla" do
    post "/bla", {name: "123"}.to_json
    assert last_response.ok?
  end

  test "should return content type json for POST /bla" do
    post "/bla", {name: "123"}.to_json
    assert_equal last_response.headers['Content-Type'], "application/josn"
  end

  test "should return the param name for POST /bla" do
    response = { "name" => "123" }.to_json
    post "/bla", response
    assert_equal last_response.body, response
  end
end
