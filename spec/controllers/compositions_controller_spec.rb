require 'rails_helper'

RSpec.describe CompositionsController do
  before(:each) do
    @user = create(:user)
    @anon_user = create(:anonymous_user)
    @map = create(:map)
    @map_segment = create(:map_segment, map: @map)
    @hero1 = create(:hero, name: 'Mei')
    @hero2 = create(:hero, name: 'Soldier: 76')

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
      sign_in @user
      post :save, params: {
        player_name: 'chocotaco', hero_id: @hero1.id,
        map_segment_id: @map_segment.id, format: :json
      }
      expect(response).to be_success, response.body
    end

    it 'loads successfully for anonymous user' do
      post :save, params: {
        player_name: 'practicalLlama', hero_id: @hero1.id,
        map_segment_id: @map_segment.id, format: :json
      }
      expect(response).to be_success, response.body
    end

    it 'creates a new composition for authenticated user' do
      sign_in @user

      expect do
        post :save, params: {
          player_name: 'chocotaco', hero_id: @hero1.id,
          map_segment_id: @map_segment.id, format: :json
        }
      end.to change { Composition.count }.by(1)
    end

    it 'creates a new composition for anonymous user' do
      expect do
        post :save, params: {
          player_name: 'FabulousPrizes', hero_id: @hero1.id,
          map_segment_id: @map_segment.id, format: :json
        }
      end.to change { @anon_user.compositions.count }.by(1)
    end

    it 'creates a new player for new name for authenticated user' do
      sign_in @user

      expect do
        post :save, params: {
          player_name: 'chocotaco', hero_id: @hero1.id,
          map_segment_id: @map_segment.id, format: :json
        }
      end.to change { Player.count }.by(1)
    end

    it 'creates a new player for new name for anonymous user' do
      expect do
        post :save, params: {
          player_name: 'NiftyThrifty618', hero_id: @hero1.id,
          map_segment_id: @map_segment.id, format: :json
        }
      end.to change { @anon_user.created_players.count }.by(1)
    end

    it 'reuses existing player for authenticated user' do
      sign_in @user
      player = create(:player, creator: @user)

      expect do
        post :save, params: {
          player_name: 'gloriousNewPerson', hero_id: @hero1.id,
          map_segment_id: @map_segment.id, format: :json, player_id: player.id
        }
      end.not_to change { Player.count }
      expect(player.reload.name).to eq('gloriousNewPerson')
    end

    it 'creates a new player selection for authenticated user' do
      sign_in @user

      expect do
        post :save, params: {
          player_name: 'chocotaco', hero_id: @hero1.id,
          map_segment_id: @map_segment.id, format: :json
        }
      end.to change { PlayerSelection.count }.by(1)
    end

    it 'no-op for existing player selection for authenticated user' do
      sign_in @user

      player = create(:player, creator: @user)
      composition = create(:composition, user: @user, map: @map)
      player_selection = create(:player_selection, composition: composition,
                                player: player, hero: @hero1,
                                map_segment: @map_segment)

      expect do
        post :save, params: {
          player_name: player.name, hero_id: @hero2.id, format: :json,
          composition_id: composition.id, map_segment_id: @map_segment.id,
          player_id: player.id
        }
      end.not_to change { PlayerSelection.count }
      expect(player_selection.reload.hero).to eq(@hero2)
    end
  end
end
