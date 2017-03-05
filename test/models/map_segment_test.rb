require 'test_helper'

class MapSegmentTest < ActiveSupport::TestCase
  test "requires a name" do
    map_segment = MapSegment.new
    refute_predicate map_segment, :valid?
    assert_predicate map_segment.errors[:name], :any?
  end

  test "requires a map" do
    map_segment = MapSegment.new
    refute_predicate map_segment, :valid?
    assert_predicate map_segment.errors[:map], :any?
  end
end
