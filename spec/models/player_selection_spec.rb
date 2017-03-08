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

  it 'requires a map segment' do
    ps = PlayerSelection.new
    expect(ps.valid?).to be_falsey
    expect(ps.errors[:map_segment].any?).to be_truthy
  end

  it 'requires a unique map segment + composition + player-hero combo' do
    existing = create(:player_selection)
    ps = PlayerSelection.new(map_segment: existing.map_segment,
                             composition: existing.composition,
                             player_hero: existing.player_hero)
    expect(ps.valid?).to be_falsey
    expect(ps.errors[:player_hero_id].any?).to be_truthy
  end
end
