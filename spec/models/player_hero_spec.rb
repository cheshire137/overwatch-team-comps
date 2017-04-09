require 'rails_helper'

describe PlayerHero do
  it 'requires a player' do
    player_hero = PlayerHero.new
    expect(player_hero.valid?).to be_falsey
    expect(player_hero.errors[:player].any?).to be_truthy
  end

  it 'requires a hero' do
    player_hero = PlayerHero.new
    expect(player_hero.valid?).to be_falsey
    expect(player_hero.errors[:hero].any?).to be_truthy
  end

  it 'requires an integer confidence' do
    player_hero = PlayerHero.new(confidence: 15.5)
    expect(player_hero.valid?).to be_falsey
    expect(player_hero.errors[:confidence].any?).to be_truthy
  end
end
