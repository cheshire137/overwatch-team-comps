require 'rails_helper'

RSpec.describe Users::OmniauthCallbacksController do
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
    render_views

    it 'loads successfully' do
      get :finish_signup, session: { 'devise.bnet_data' => OmniAuth.config.mock_auth[:bnet] }
      expect(response).to be_success
      expect(response.body).to include('coollady#1965')
    end
  end

  describe 'POST finished_signup' do
    render_views

    it 'creates a user' do
      expect do
        post :finished_signup, params: { email: 'test@example.com' },
          session: { 'devise.bnet_data' => OmniAuth.config.mock_auth[:bnet] }
      end.to change { User.count }.by(1)
      expect(response).to redirect_to('/')
      expect(flash[:notice]).to eq('Successfully authenticated from Battle.net account.')

      user = User.last
      expect(user.email).to eq('test@example.com')
      expect(user.provider).to eq('bnet')
      expect(user.uid).to eq('123456')
      expect(user.battletag).to eq('coollady#1965')
    end

    it 'does not save user when email is omitted' do
      expect do
        post :finished_signup, params: { email: '' },
          session: { 'devise.bnet_data' => OmniAuth.config.mock_auth[:bnet] }
      end.not_to change { User.count }
      expect(response).to be_success
      expect(response.body).to include('coollady#1965')
      expect(response.body).to include('Please provide an email address.')
    end
  end
end
