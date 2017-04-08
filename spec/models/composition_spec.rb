require 'rails_helper'

describe Composition do
  before(:all) do
    @anon_user = User.anonymous || create(:anonymous_user)
  end

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
    composition = Composition.new(user: @anon_user)
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
    session1 = '123abc'
    session2 = '987zyx'

    session1_comp = create(:composition, user: @anon_user, session_id: session1)
    expect(session1_comp.name).to eq('Composition 1')

    session2_comp = create(:composition, user: @anon_user, session_id: session2)
    expect(session2_comp.name).to eq('Composition 1')

    session1_comp2 = build(:composition, user: @anon_user, session_id: session1)
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
    existing = create(:composition, user: @anon_user, session_id: '123abc')
    composition = Composition.new(name: existing.name, user: existing.user,
                                  session_id: existing.session_id)
    expect(composition.valid?).to be_falsey
    expect(composition.errors[:name].any?).to be_truthy
  end

  context '#mine?' do
    it 'returns true when owned by given registered user' do
      user = create(:user)
      composition = build(:composition, user: user)

      expect(composition.mine?(user: user, session_id: nil)).to eq(true)
    end

    it 'returns true when owned by given anonymous user' do
      composition = build(:composition, user: @anon_user, session_id: '123')

      expect(composition.mine?(user: nil, session_id: '123')).to eq(true)
    end

    it 'returns false when not owned by given registered user' do
      user = create(:user)
      composition = build(:composition)

      expect(composition.mine?(user: user, session_id: nil)).to eq(false)
    end

    it 'returns false when not owned by given anonymous user' do
      composition = build(:composition)

      expect(composition.mine?(user: nil, session_id: '123')).to eq(false)
    end
  end

  context '#touch_if_mine' do
    it 'changes updated_at when given user owns the composition' do
      user = create(:user)
      before_value = 1.week.ago
      composition = create(:composition, user: user, updated_at: before_value)
      expect(composition.updated_at).to eq(before_value)

      composition.touch_if_mine(user: user, session_id: nil)
      expect(composition.reload.updated_at).not_to eq(before_value)
    end

    it 'changes updated_at when given anon user owns the composition' do
      before_value = 1.week.ago
      composition = create(:composition, user: @anon_user, session_id: '123',
                           updated_at: before_value)
      expect(composition.updated_at).to eq(before_value)

      composition.touch_if_mine(user: nil, session_id: '123')
      expect(composition.reload.updated_at).not_to eq(before_value)
    end

    it 'does not change updated_at when user does not own comp' do
      user = create(:user)
      before_value = 1.week.ago
      composition = create(:composition, updated_at: before_value)
      expect(composition.updated_at).to eq(before_value)

      composition.touch_if_mine(user: user, session_id: nil)
      expect(composition.reload.updated_at).to eq(before_value)
    end

    it 'does not change updated_at when anon user does not own comp' do
      before_value = 1.week.ago
      composition = create(:composition, updated_at: before_value)
      expect(composition.updated_at).to eq(before_value)

      composition.touch_if_mine(user: nil, session_id: '123')
      expect(composition.reload.updated_at).to eq(before_value)
    end
  end
end
