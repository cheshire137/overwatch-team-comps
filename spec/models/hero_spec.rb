require 'rails_helper'

describe Hero do
  it "requires a name" do
    hero = Hero.new
    expect(hero.valid?).to be_falsey
    expect(hero.errors[:name].any?).to be_truthy
  end
end
