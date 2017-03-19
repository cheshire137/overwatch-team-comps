require 'rails_helper'

RSpec.describe 'users API', type: :request do
  before(:each) do
    @user = create(:user)
  end

  describe 'GET /api/user' do
    it 'has auth: false for anonymous user' do
      get '/api/user'
      json = JSON.parse(response.body)
      expect(json['auth']).to eq(false)
      expect(json['battletag']).to be_nil
    end

    it 'has auth: true for authenticated user' do
      sign_in @user
      get '/api/user'
      json = JSON.parse(response.body)
      expect(json['auth']).to eq(true)
      expect(json['battletag']).to eq(@user.battletag)
    end
  end
end
