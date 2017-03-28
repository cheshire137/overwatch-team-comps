require 'rails_helper'

RSpec.describe 'users API', type: :request do
  before(:each) do
    @user = create(:user)
  end

  describe 'GET /api/user' do
    it 'has auth: false for anonymous user' do
      get '/api/user'
      json = JSON.parse(response.body)
      user = json['user']
      expect(user['auth']).to eq(false)
      expect(user['battletag']).to be_nil
    end

    it 'has auth: true for authenticated user' do
      sign_in @user
      get '/api/user'
      json = JSON.parse(response.body)
      user = json['user']
      expect(user['auth']).to eq(true)
      expect(user['battletag']).to eq(@user.battletag)
    end
  end
end
