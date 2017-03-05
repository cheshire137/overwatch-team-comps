require 'test_helper'

class PlayerTest < ActiveSupport::TestCase
  test "requires a name" do
    player = Player.new
    refute_predicate player, :valid?
    assert_predicate player.errors[:name], :any?
  end
end
