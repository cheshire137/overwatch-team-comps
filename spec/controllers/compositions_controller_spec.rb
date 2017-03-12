require 'rails_helper'

RSpec.describe CompositionsController do
  before(:each) do
    @user = create(:user)
    @anon_user = create(:anonymous_user)
    @map = create(:map)
    @map_segment = create(:map_segment, map: @map)
    @hero1 = create(:hero, name: 'Mei')
    @hero2 = create(:hero, name: 'Soldier: 76')

    @request.session.id = '8675309'
    @request.env['devise.mapping'] = Devise.mappings[:user]
  end

  describe 'GET last_composition' do
    it 'loads successfully for auth user without a composition' do
      sign_in @user
      get :last_composition, params: { format: :json }
      expect(response).to be_success, response.body
    end

    it 'loads successfully for auth user with a composition' do
      create(:composition, user: @user)
      sign_in @user
      get :last_composition, params: { format: :json }
      expect(response).to be_success, response.body
    end

    it 'loads successfully for anon user' do
      get :last_composition, params: { format: :json }
      expect(response).to be_success, response.body
    end
  end

  describe 'POST save' do
    it 'loads successfully for authenticated user' do
      player = create(:player, creator: @user)

      sign_in @user
      post :save, params: {
        player_id: player.id, hero_id: @hero1.id,
        map_segment_id: @map_segment.id, format: :json
      }

      expect(response).to be_success, response.body
    end

    it 'loads successfully for anonymous user' do
      player = create(:player, creator: @anon_user, creator_session_id: '8675309')

      post :save, params: {
        player_id: player.id, hero_id: @hero1.id,
        map_segment_id: @map_segment.id, format: :json
      }

      expect(response).to be_success, response.body
    end

    it "does not allow updating another user's composition" do
      sign_in @user
      composition = create(:composition, map: @map)
      new_map = create(:map, name: 'Oasis')
      map_segment = create(:map_segment, map: new_map)

      expect do
        post :save, params: {
          format: :json, composition_id: composition.id,
          map_segment_id: map_segment.id
        }
      end.not_to change { Composition.count }
      expect(composition.reload.map).to eq(@map)
      expect(response).to have_http_status(400)
    end

    it 'creates a new composition for authenticated user' do
      sign_in @user

      expect do
        post :save, params: {
          player_name: 'chocotaco', hero_id: @hero1.id,
          map_segment_id: @map_segment.id, format: :json
        }
      end.to change { Composition.count }.by(1)
      expect(response).to be_success
    end

    it 'creates a new composition for anonymous user' do
      expect do
        post :save, params: {
          player_name: 'FabulousPrizes', hero_id: @hero1.id,
          map_segment_id: @map_segment.id, format: :json
        }
      end.to change { @anon_user.compositions.count }.by(1)
      expect(response).to be_success
    end

    it 'creates a new player selection for authenticated user' do
      sign_in @user
      player = create(:player, creator: @user)

      expect do
        post :save, params: {
          player_id: player.id, hero_id: @hero1.id,
          map_segment_id: @map_segment.id, format: :json
        }
      end.to change { PlayerSelection.count }.by(1)
      expect(response).to be_success
    end

    it 'no-op for existing player selection for authenticated user' do
      sign_in @user

      player = create(:player, creator: @user)
      composition = create(:composition, user: @user, map: @map)
      comp_player = create(:composition_player, composition: composition,
                           player: player)
      player_selection = create(:player_selection, composition_player: comp_player,
                                hero: @hero1, map_segment: @map_segment)

      expect do
        post :save, params: {
          hero_id: @hero2.id, format: :json, player_id: player.id,
          composition_id: composition.id, map_segment_id: @map_segment.id,
          player_position: comp_player.position
        }
      end.not_to change { PlayerSelection.count }

      expect(response).to be_success, response.body
      expect(player_selection.reload.hero).to eq(@hero2)
    end
  end
end
