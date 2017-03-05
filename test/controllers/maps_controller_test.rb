require 'test_helper'

class MapsControllerTest < ActionDispatch::IntegrationTest
  test "loads index JSON" do
    get maps_path, params: { format: :json }
    assert_response :success
  end
end
