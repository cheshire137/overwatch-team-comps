require 'rails_helper'

describe PlayerSelection do
  it "requires a player-hero" do
    ps = PlayerSelection.new
    expect(ps.valid?).to be_falsey
    expect(ps.errors[:player_hero].any?).to be_truthy
  end

  it "requires a composition" do
    ps = PlayerSelection.new
    expect(ps.valid?).to be_falsey
    expect(ps.errors[:composition].any?).to be_truthy
  end
end
