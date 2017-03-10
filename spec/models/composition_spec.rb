require 'rails_helper'

describe Composition do
  it "requires a map" do
    composition = Composition.new
    expect(composition.valid?).to be_falsey
    expect(composition.errors[:map].any?).to be_truthy
  end

  it 'requires a user' do
    composition = Composition.new
    expect(composition.valid?).to be_falsey
    expect(composition.errors[:user].any?).to be_truthy
  end

  it 'requires a session ID if the user is anonymous' do
    anon_user = create(:anonymous_user)
    composition = Composition.new(user: anon_user)
    expect(composition.valid?).to be_falsey
    expect(composition.errors[:session_id].any?).to be_truthy
  end

  it 'sets composition name before validation' do
    user = create(:user)
    composition = Composition.new(user: user)
    composition.valid?
    expect(composition.errors[:name].any?).to be_falsey
    expect(composition.name).not_to be_nil
  end

  it 'requires a unique name per user + map combo' do
    existing = create(:composition)
    composition = Composition.new(name: existing.name, map: existing.map,
                                  user: existing.user)
    expect(composition.valid?).to be_falsey
    expect(composition.errors[:name].any?).to be_truthy
  end
end
