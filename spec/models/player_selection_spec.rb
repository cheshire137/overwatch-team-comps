require 'rails_helper'

describe PlayerSelection do
  it 'requires a player' do
    ps = PlayerSelection.new
    expect(ps.valid?).to be_falsey
    expect(ps.errors[:player].any?).to be_truthy
  end

  it 'requires a hero' do
    ps = PlayerSelection.new
    expect(ps.valid?).to be_falsey
    expect(ps.errors[:hero].any?).to be_truthy
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

  it 'requires a unique map segment + composition + player combo' do
    existing = create(:player_selection)
    new_hero = create(:hero, name: 'Orisa')
    ps = PlayerSelection.new(map_segment: existing.map_segment,
                             composition: existing.composition,
                             player: existing.player,
                             hero: new_hero)
    expect(ps.valid?).to be_falsey
    expect(ps.errors[:player_id].any?).to be_truthy
  end
end
