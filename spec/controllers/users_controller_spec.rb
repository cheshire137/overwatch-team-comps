require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe 'GET current' do
    it 'responds successfully for authenticated user' do
      user = create(:user)
      sign_in user
      get :current, params: { format: :json }
      expect(response).to be_success
    end

    it 'responds successfully for anonymous user' do
      get :current, params: { format: :json }
      expect(response).to be_success
    end
  end

  describe 'PUT update' do
    it 'does not work for anonymous user' do
      put :update, params: { format: :json, email: 'hey@example.com' }
      expect(response).to have_http_status(401)
    end

    it 'wipes region and platform if empty strings are given' do
      user = create(:user, email: 'me@example.com')
      sign_in user
      put :update, params: {
        format: :json, email: 'me@example.com', region: '',
        platform: ''
      }
      expect(response).to be_success
      expect(user.reload.email).to eq('me@example.com')
      expect(user.region).to be_nil
      expect(user.platform).to be_nil
    end

    it 'updates current user' do
      user = create(:user)
      sign_in user
      put :update, params: {
        format: :json, email: 'hey@example.com', region: 'eu',
        platform: 'xbl'
      }
      expect(response).to be_success
      expect(user.reload.email).to eq('hey@example.com')
      expect(user.region).to eq('eu')
      expect(user.platform).to eq('xbl')
    end
  end
end
