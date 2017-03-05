require 'test_helper'

class MapTest < ActiveSupport::TestCase
  test "requires a name" do
    map = Map.new
    refute_predicate map, :valid?
    assert_predicate map.errors[:name], :any?
  end

  test "requires a unique name" do
    map1 = Map.create!(name: "Dorado")
    map2 = Map.new(name: map1.name)
    refute_predicate map2, :valid?
    assert_predicate map2.errors[:name], :any?
  end
end
