require 'rails_helper'

describe User do
  context "Anonymous user" do
    before do
      create :anonymous_user
    end

    it "is found via email" do
      expect(User.find_by_email("anonymous@ghost.com")).to_not be_nil
    end

    it "is found via scope" do
      expect(User.anonymous).to_not be_nil
    end
  end
end
