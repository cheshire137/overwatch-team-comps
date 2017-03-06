require 'rails_helper'

describe Composition do
  it "requires a map" do
    composition = Composition.new
    expect(composition.valid?).to be_falsey
    expect(composition.errors[:map].any?).to be_truthy
  end
end
