require 'test_helper'

class PlayerSelectionTest < ActiveSupport::TestCase
  test "requires a player-hero" do
    ps = PlayerSelection.new
    refute_predicate ps, :valid?
    assert_predicate ps.errors[:player_hero], :any?
  end

  test "requires a composition" do
    ps = PlayerSelection.new
    refute_predicate ps, :valid?
    assert_predicate ps.errors[:composition], :any?
  end
end
