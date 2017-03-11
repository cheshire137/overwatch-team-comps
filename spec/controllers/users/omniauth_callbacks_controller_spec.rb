require 'rails_helper'

RSpec.describe Users::OmniauthCallbacksController do
  before(:each) do
    OmniAuth.config.test_mode = true

    OmniAuth.config.mock_auth[:bnet] = OmniAuth::AuthHash.new(
      provider: 'bnet',
      uid: '123456'
    )

    @request.env['devise.mapping'] = Devise.mappings[:user]
    @request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:bnet]
  end

  describe 'POST bnet' do
    it 'continues sign-up flow for new user' do
      expect { post :bnet }.not_to change { User.count }
      expect(session['devise.bnet_data']).not_to be_nil
      expect(response).to redirect_to('/users/finish_signup')
    end

    it 'redirects to home for existing user' do
      user = create(:user, provider: 'bnet', uid: '123456')
      expect { post :bnet }.not_to change { User.count }
      expect(session['devise.bnet_data']).to be_nil
      expect(response).to redirect_to('/')
    end
  end
end
