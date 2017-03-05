require 'test_helper'

class MapTest < ActiveSupport::TestCase
  test "requires a name" do
    map = Map.new
    refute_predicate map, :valid?
    assert_predicate map.errors[:name], :any?
  end
end
