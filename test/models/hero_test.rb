require 'test_helper'

class HeroTest < ActiveSupport::TestCase
  test "requires a name" do
    hero = Hero.new
    refute_predicate hero, :valid?
    assert_predicate hero.errors[:name], :any?
  end
end
