require 'rails_helper'

RSpec.describe CompositionPlayer, type: :model do
  it 'requires a composition' do
    comp_player = CompositionPlayer.new
    expect(comp_player.valid?).to be_falsey
    expect(comp_player.errors[:composition].any?).to be_truthy
  end

  it 'requires a player' do
    comp_player = CompositionPlayer.new
    expect(comp_player.valid?).to be_falsey
    expect(comp_player.errors[:player].any?).to be_truthy
  end

  it 'sets position' do
    comp_player = create(:composition_player, position: nil)
    expect(comp_player.position).to eq(0)

    comp_player2 = create(:composition_player, position: nil,
                          composition: comp_player.composition)
    expect(comp_player2.position).to eq(1)
  end

  it 'disallows position less than 0' do
    comp_player = build(:composition_player, position: -1)
    expect(comp_player.valid?).to be_falsey
    expect(comp_player.errors[:position].any?).to be_truthy
  end

  it 'disallows position greater than 5' do
    comp_player = build(:composition_player, position: 6)
    expect(comp_player.valid?).to be_falsey
    expect(comp_player.errors[:position].any?).to be_truthy
  end

  it 'disallows more than 6 players per composition' do
    composition = create(:composition)
    6.times { create(:composition_player, composition: composition) }
    seventh = build(:composition_player, composition: composition)
    expect(seventh.valid?).to be_falsey
    expect(seventh.errors[:composition].any?).to be_truthy
  end

  it 'requires a unique player per composition' do
    composition = create(:composition)
    player = create(:player)
    create(:composition_player, composition: composition,
           player: player)
    comp_player = build(:composition_player, composition: composition,
                        player: player)
    expect(comp_player.valid?).to be_falsey
    expect(comp_player.errors[:player_id].any?).to be_truthy
  end
end
