require 'rails_helper'

describe User do
  before(:all) do
    User.anonymous || create(:anonymous_user)
  end

  context "Anonymous user" do
    it "found via email" do
      expect(User.find_by_email(User::ANONYMOUS_EMAIL)).to_not be_nil
    end

    it "found via anonymous method" do
      expect(User.anonymous).to_not be_nil
    end
  end
end
