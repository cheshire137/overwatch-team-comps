require 'rails_helper'

RSpec.describe 'heroes API', type: :request do
  before(:each) do
    @user = create(:user)
    @hero1 = create(:hero, name: 'Ana')
    @hero2 = create(:hero, name: 'Pharah')
  end

  describe 'GET pool' do
    it 'includes all heroes for authenticated user' do
      sign_in @user

      get '/api/heroes/pool'

      expect(response.body).to include(@hero1.name)
      expect(response.body).to include(@hero2.name)
    end
  end
end
