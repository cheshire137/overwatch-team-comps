require 'rails_helper'

RSpec.describe CompositionsController do
  before(:all) do
    @anon_user = User.anonymous || create(:anonymous_user)
  end

  before(:each) do
    @user = create(:user)
    @map = create(:map)
    @map_segment1 = create(:map_segment, map: @map)
    @map_segment2 = create(:map_segment, map: @map)
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
        map_segment_id: @map_segment1.id, format: :json
      }

      expect(response).to be_success, response.body
    end

    it 'loads successfully for anonymous user' do
      player = create(:player, creator: @anon_user, creator_session_id: '8675309')

      post :save, params: {
        player_id: player.id, hero_id: @hero1.id,
        map_segment_id: @map_segment1.id, format: :json
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
          map_segment_id: @map_segment1.id, format: :json
        }
      end.to change { Composition.count }.by(1)
      expect(response).to be_success
    end

    it 'creates a new composition for anonymous user' do
      expect do
        post :save, params: {
          player_name: 'FabulousPrizes', hero_id: @hero1.id,
          map_segment_id: @map_segment1.id, format: :json
        }
      end.to change { @anon_user.compositions.count }.by(1)
      expect(response).to be_success
    end

    it 'populates heroes for each map segment for authenticated user' do
      sign_in @user
      player = create(:player, creator: @user)

      expect do
        post :save, params: {
          player_id: player.id, hero_id: @hero1.id,
          map_segment_id: @map_segment1.id, format: :json
        }
      end.to change { PlayerSelection.count }.by(2)
      expect(response).to be_success
    end

    it 'creates composition with name and notes' do
      expect do
        post :save, params: {
          name: 'My Sweet Dive Comp', notes: 'o boy', map_id: @map.id,
          format: :json
        }
      end.to change { @anon_user.compositions.count }.by(1)
      expect(response).to be_success

      composition = @anon_user.compositions.last
      expect(composition.name).to eq('My Sweet Dive Comp')
      expect(composition.notes).to eq('o boy')
      expect(composition.map).to eq(@map)
      expect(composition.session_id).to eq('8675309')
    end

    it 'updates existing player selection for authenticated user' do
      sign_in @user

      player = create(:player, creator: @user)
      composition = create(:composition, user: @user, map: @map)
      comp_player = create(:composition_player, composition: composition,
                           player: player)
      player_selection1 = create(:player_selection, composition_player: comp_player,
                                 hero: @hero1, map_segment: @map_segment1)
      player_selection2 = create(:player_selection, composition_player: comp_player,
                                 hero: @hero1, map_segment: @map_segment2)

      expect do
        post :save, params: {
          hero_id: @hero2.id, format: :json, player_id: player.id,
          composition_id: composition.id, map_segment_id: @map_segment1.id,
          player_position: comp_player.position
        }
      end.not_to change { PlayerSelection.count }

      expect(response).to be_success, response.body
      expect(player_selection1.reload.hero).to eq(@hero2)
      expect(player_selection2.reload.hero).to eq(@hero1)
    end
  end
end
