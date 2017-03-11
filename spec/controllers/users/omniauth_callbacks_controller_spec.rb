require 'rails_helper'

RSpec.describe Users::OmniauthCallbacksController do
  render_views

  before(:each) do
    OmniAuth.config.test_mode = true

    OmniAuth.config.mock_auth[:bnet] = OmniAuth::AuthHash.new(
      provider: 'bnet',
      uid: '123456',
      info: { battletag: 'coollady#1965' }
    )

    @request.env['devise.mapping'] = Devise.mappings[:user]
    @request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:bnet]
  end

  describe 'POST bnet' do
    it 'continues sign-up flow for new user' do
      expect { post :bnet }.not_to change { User.count }
      expect(session['devise.bnet_data']).to eq(OmniAuth.config.mock_auth[:bnet])
      expect(response).to redirect_to('/users/finish_signup')
    end

    it 'redirects to home for existing user' do
      user = create(:user, provider: 'bnet', uid: '123456')
      expect { post :bnet }.not_to change { User.count }
      expect(session['devise.bnet_data']).to be_nil
      expect(response).to redirect_to('/')
    end
  end

  describe 'GET finish_signup' do
    it 'loads successfully' do
      get :finish_signup, session: { 'devise.bnet_data' => OmniAuth.config.mock_auth[:bnet] }
      expect(response).to be_success
      expect(response.body).to include('coollady#1965')
    end
  end
end
