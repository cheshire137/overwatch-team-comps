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
end
