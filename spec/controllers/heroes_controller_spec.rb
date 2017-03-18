require 'rails_helper'

RSpec.describe HeroesController, type: :controller do
  before(:each) do
    @user = create(:user)
    @hero = create(:hero, name: 'Mercy')
  end

  describe 'GET pool' do
    it '401s when user is not signed in' do
      get :pool, params: { format: :json }
      expect(response).to have_http_status(401)
    end

    it 'loads successfully for authenticated user' do
      sign_in @user
      get :pool, params: { format: :json }
      expect(response).to be_success
    end
  end

  describe 'POST save' do
    it 'updates existing PlayerHero' do
      player = create(:player, user: @user)
      player_hero = create(:player_hero, player: player)

      sign_in @user

      expect do
        post :save, params: { format: :json, hero_id: player_hero.hero_id,
                              confidence: 35 }
      end.not_to change { PlayerHero.count }

      expect(response).to be_success
      expect(player_hero.reload.confidence).to eq(35)
    end

    it 'creates new PlayerHero' do
      player = create(:player, user: @user)
      sign_in @user

      expect do
        post :save, params: { format: :json, hero_id: @hero.id,
                              confidence: 70 }
      end.to change { PlayerHero.count }.by(1)

      expect(response).to be_success

      player_hero = PlayerHero.where(player_id: player).last
      expect(player_hero.confidence).to eq(70)
      expect(player_hero.hero).to eq(@hero)
    end

    it 'creates new Player when none is tied to the current user' do
      sign_in @user

      expect do
        post :save, params: { format: :json, hero_id: @hero.id,
                              confidence: 55 }
      end.to change { Player.count }.by(1)

      expect(response).to be_success

      player = Player.last
      expect(player.user).to eq(@user)
      expect(player.name).to eq(@user.battletag)
    end

    it '401s when user is not signed in' do
      post :save, params: { format: :json }
      expect(response).to have_http_status(401)
    end
  end
end
