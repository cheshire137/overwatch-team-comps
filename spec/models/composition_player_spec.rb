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
                          composition: comp_player.composition,
                          player: comp_player.player)
    expect(comp_player2.position).to eq(1)
  end
end
