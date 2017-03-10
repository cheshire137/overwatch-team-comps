require 'rails_helper'

describe Player do
  it "requires a name" do
    player = Player.new
    expect(player.valid?).to be_falsey
    expect(player.errors[:name].any?).to be_truthy
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
