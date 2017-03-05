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

  test "requires a unique map + name combination" do
    map = Map.create!(name: "Route 66")
    map_segment1 = MapSegment.create!(name: "Payload 1", map: map)

    map_segment2 = MapSegment.new(name: map_segment1.name,
                                  map: map_segment1.map)
    refute_predicate map_segment2, :valid?
    assert_predicate map_segment2.errors[:map_id], :any?
  end
end
