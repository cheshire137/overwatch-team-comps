require 'rails_helper'

describe Player do
  it "requires a name" do
    player = Player.new
    expect(player.valid?).to be_falsey
    expect(player.errors[:name].any?).to be_truthy
  end
end
