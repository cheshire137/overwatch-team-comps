require 'rails_helper'

describe Composition do
  it "requires a map" do
    composition = Composition.new
    expect(composition.valid?).to be_falsey
    expect(composition.errors[:map].any?).to be_truthy
  end

  it 'generates a slug from the map and name' do
    map = create(:map, name: "Big Earl's Party Palace")
    composition = create(:composition, map: map, name: 'My Fave Dive Comp')
    expect(composition.slug).to eq('big-earl-s-party-palace-my-fave-dive-comp')
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

  it 'sets composition name for anonymous user scoped by session' do
    anon_user = create(:anonymous_user)

    session1 = '123abc'
    session2 = '987zyx'

    session1_comp = create(:composition, user: anon_user, session_id: session1)
    expect(session1_comp.name).to eq('Composition 1')

    session2_comp = create(:composition, user: anon_user, session_id: session2)
    expect(session2_comp.name).to eq('Composition 1')

    session1_comp2 = build(:composition, user: anon_user, session_id: session1)
    session1_comp2.valid?
    expect(session1_comp2.name).to eq('Composition 2')
  end

  it 'requires a unique name per user for authenticated user' do
    existing = create(:composition)
    composition = Composition.new(name: existing.name, user: existing.user)
    expect(composition.valid?).to be_falsey
    expect(composition.errors[:name].any?).to be_truthy
  end

  it 'requires a unique name per user for anonymous user' do
    anon_user = create(:anonymous_user)
    existing = create(:composition, user: anon_user, session_id: '123abc')
    composition = Composition.new(name: existing.name, user: existing.user,
                                  session_id: existing.session_id)
    expect(composition.valid?).to be_falsey
    expect(composition.errors[:name].any?).to be_truthy
  end
end
