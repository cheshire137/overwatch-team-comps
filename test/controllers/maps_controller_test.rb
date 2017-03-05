require 'test_helper'

class MapsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @map = create(:map)
    @map_segment = create(:map_segment, map: @map)
  end

  test "loads index JSON" do
    get "/api/maps"
    assert_response :success
    assert_includes response.body, @map.name
    assert_includes response.body, @map.map_type
    assert_includes response.body, @map_segment.name
  end
end
