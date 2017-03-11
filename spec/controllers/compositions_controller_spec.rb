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

    it "does not allow updating another user's player" do
      sign_in @user
      player = create(:player, name: 'oldName32')
      composition = create(:composition, map: @map, user: @user)

      expect do
        post :save, params: {
          player_name: 'newName64', player_id: player.id, format: :json,
          composition_id: composition.id
        }
      end.not_to change { Player.count }
      expect(player.reload.name).to eq('oldName32')
      expect(response).to have_http_status(400)
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

    it 'allows creating just a player in the composition' do
      sign_in @user
      composition = create(:composition, map: @map, user: @user)

      expect do
        post :save, params: {
          player_name: 'newName64', format: :json, composition_id: composition.id
        }
      end.to change { @user.created_players.count }.by(1)
      expect(response).to be_success
      expect(composition.players.pluck(:name)).to eq(['newName64'])
    end

    it 'allows creating a player in a new composition' do
      sign_in @user

      expect do
        post :save, params: {
          player_name: 'newName64', format: :json, map_segment_id: @map_segment.id
        }
      end.to change { @user.created_players.count }.by(1)
      expect(response).to be_success
      expect(@user.compositions.last).not_to be_nil
      expect(@user.compositions.last.players.pluck(:name)).to eq(['newName64'])
    end

    it 'allows updating just a player name' do
      sign_in @user
      player = create(:player, name: 'oldName32', creator: @user)
      composition = create(:composition, map: @map, user: @user)
      selection = create(:player_selection, composition: composition,
                         player: player, map_segment: @map_segment,
                         hero: @hero1)

      expect do
        post :save, params: {
          player_name: 'newName64', player_id: player.id, format: :json,
          composition_id: composition.id
        }
      end.not_to change { Player.count }
      expect(response).to be_success
      expect(player.reload.name).to eq('newName64')
      expect(composition.reload.map).to eq(@map)
      expect(selection.reload.player).to eq(player)
      expect(selection.map_segment).to eq(@map_segment)
      expect(selection.hero).to eq(@hero1)
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

    it 'creates a new player for new name for authenticated user' do
      sign_in @user

      expect do
        post :save, params: {
          player_name: 'chocotaco', hero_id: @hero1.id,
          map_segment_id: @map_segment.id, format: :json
        }
      end.to change { Player.count }.by(1)
      expect(response).to be_success
      expect(@user.compositions.last.players.pluck(:name)).to eq(['chocotaco'])
    end

    it 'creates a new player for new name for anonymous user' do
      expect do
        post :save, params: {
          player_name: 'NiftyThrifty618', hero_id: @hero1.id,
          map_segment_id: @map_segment.id, format: :json
        }
      end.to change { @anon_user.created_players.count }.by(1)
      expect(response).to be_success
      expect(@anon_user.compositions.last.players.pluck(:name)).to eq(['NiftyThrifty618'])
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
      expect(response).to be_success
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
      expect(response).to be_success
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
      expect(response).to be_success
      expect(player_selection.reload.hero).to eq(@hero2)
    end
  end
end
