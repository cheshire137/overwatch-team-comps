require 'rails_helper'

RSpec.describe 'users API', type: :request do
  before(:each) do
    @user = create(:user)
  end

  describe 'GET /api/user' do
    it 'includes battletag when user is authenticated' do
      sign_in @user
      get '/api/user'
      expect(response.body).to include(@user.battletag)
    end

    it 'has auth: false for anonymous user' do
      get '/api/user'
      json = JSON.parse(response.body)
      expect(json['auth']).to eq(false)
    end

    it 'has auth: true for authenticated user' do
      sign_in @user
      get '/api/user'
      json = JSON.parse(response.body)
      expect(json['auth']).to eq(true)
    end
  end
end
