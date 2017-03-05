require 'test_helper'

class MapsControllerTest < ActionDispatch::IntegrationTest
  test "loads index JSON" do
    get "/api/maps"
    assert_response :success
  end
end
