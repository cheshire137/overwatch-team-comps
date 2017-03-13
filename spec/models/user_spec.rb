require 'rails_helper'

describe User do
  context "Anonymous user" do
    before do
      create :anonymous_user
    end

    it "found via email" do
      expect(User.find_by_email(User::ANONYMOUS_EMAIL)).to_not be_nil
    end

    it "found via anonymous method" do
      expect(User.anonymous).to_not be_nil
    end
  end
end
