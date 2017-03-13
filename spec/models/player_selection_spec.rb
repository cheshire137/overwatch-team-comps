require 'rails_helper'

describe PlayerSelection do
  it 'requires a composition-player' do
    ps = PlayerSelection.new
    expect(ps.valid?).to be_falsey
    expect(ps.errors[:composition_player].any?).to be_truthy
  end

  it 'requires a hero' do
    ps = PlayerSelection.new
    expect(ps.valid?).to be_falsey
    expect(ps.errors[:hero].any?).to be_truthy
  end

  it 'requires a map segment' do
    ps = PlayerSelection.new
    expect(ps.valid?).to be_falsey
    expect(ps.errors[:map_segment].any?).to be_truthy
  end

  it 'requires the map segment be part of the composition map' do
    composition = create(:composition)
    map_segment = create(:map_segment)
    ps = PlayerSelection.new(map_segment: map_segment,
                             composition: composition)
    expect(ps.valid?).to be_falsey
    expect(ps.errors[:map_segment].any?).to be_truthy
  end

  it 'requires a unique map segment + composition-player combo' do
    existing = create(:player_selection)
    new_hero = create(:hero, name: 'Orisa')
    ps = PlayerSelection.new(map_segment: existing.map_segment,
                             composition_player: existing.composition_player,
                             hero: new_hero)
    expect(ps.valid?).to be_falsey
    expect(ps.errors[:composition_player_id].any?).to be_truthy
  end
end
