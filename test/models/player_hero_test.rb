require 'test_helper'

class PlayerHeroTest < ActiveSupport::TestCase
  test "requires a player" do
    player_hero = PlayerHero.new
    refute_predicate player_hero, :valid?
    assert_predicate player_hero.errors[:player], :any?
  end

  test "requires a hero" do
    player_hero = PlayerHero.new
    refute_predicate player_hero, :valid?
    assert_predicate player_hero.errors[:hero], :any?
  end

  test "requires an integer confidence" do
    player_hero = PlayerHero.new(confidence: 15.5)
    refute_predicate player_hero, :valid?
    assert_predicate player_hero.errors[:confidence], :any?
  end
end
