require 'rails_helper'

describe Player do
  it "requires a name" do
    player = Player.new
    expect(player.valid?).to be_falsey
    expect(player.errors[:name].any?).to be_truthy
  end

  it 'requires a unique name per authenticated creator' do
    user = create(:user)
    player1 = create(:player, creator: user)
    player2 = build(:player, creator: user, name: player1.name)
    expect(player2.valid?).to be_falsey
    expect(player2.errors[:name].any?).to be_truthy
  end

  it 'requires a unique name per anonymous creator' do
    anon_user = create(:anonymous_user)
    player1 = create(:player, creator: anon_user, creator_session_id: '123')
    player2 = build(:player, creator: anon_user, name: player1.name,
                    creator_session_id: player1.creator_session_id)
    expect(player2.valid?).to be_falsey
    expect(player2.errors[:name].any?).to be_truthy
  end

  it 'requires a creator' do
    player = Player.new
    expect(player.valid?).to be_falsey
    expect(player.errors[:creator].any?).to be_truthy
  end

  it 'requires a creator session ID if the creator is anonymous' do
    anon_user = create(:anonymous_user)
    player = Player.new(creator: anon_user)
    expect(player.valid?).to be_falsey
    expect(player.errors[:creator_session_id].any?).to be_truthy
  end
end
