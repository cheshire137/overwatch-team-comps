require 'rails_helper'

describe Map do
  it "requires a name" do
    map = Map.new
    expect(map.valid?).to be_falsey
    expect(map.errors[:name].any?).to be_truthy
  end

  it "requires a unique name" do
    map1 = Map.create!(name: "Dorado")
    map2 = Map.new(name: map1.name)
    expect(map2.valid?).to be_falsey
    expect(map2.errors[:name].any?).to be_truthy
  end

  it 'generates a slug from the name' do
    map = create(:map, name: "Big Earl's Party Palace")
    expect(map.slug).to eq('big-earl-s-party-palace')
  end
end
