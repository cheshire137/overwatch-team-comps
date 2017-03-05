require 'test_helper'

class CompositionTest < ActiveSupport::TestCase
  test "requires a map" do
    composition = Composition.new
    refute_predicate composition, :valid?
    assert_predicate composition.errors[:map], :any?
  end
end
