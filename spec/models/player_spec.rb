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

  context '#find_if_allowed' do
    it 'returns nil when anonymous user does not own player' do
      player = create(:player)
      result = Player.find_if_allowed(player.id, user: nil, session_id: '123')
      expect(result).to be_nil
    end

    it 'returns nil when authenticated user does not own player' do
      player = create(:player)
      result = Player.find_if_allowed(player.id, user: create(:user), session_id: nil)
      expect(result).to be_nil
    end

    it 'returns owned player for anonymous user' do
      anon_user = create(:anonymous_user)
      player = create(:player, creator: anon_user, creator_session_id: '123')
      result = Player.find_if_allowed(player.id, user: nil, session_id: '123')
      expect(result).to eq(player)
    end

    it 'returns owned player for authenticated user' do
      user = create(:user)
      player = create(:player, creator: user)
      result = Player.find_if_allowed(player.id, user: user, session_id: nil)
      expect(result).to eq(player)
    end
  end
end
