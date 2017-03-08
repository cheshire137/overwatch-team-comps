require 'rails_helper'

RSpec.describe 'compositions API' do
  before(:each) do
    @map = create(:map)
    @map_segment = create(:map_segment, map: @map)
    @hero1 = create(:hero, name: 'Hanzo')
    @hero2 = create(:hero, name: 'Mercy')
    @user = create(:user)
  end

  describe 'POST save' do
    it 'loads successfully for authenticated user' do
      sign_in @user
      post '/api/compositions', params: {
        player_name: 'chocotaco', hero_id: @hero1.id, map_id: @map.id
      }
      expect(response).to be_success, response.body
    end

    it 'creates a new composition' do
      sign_in @user

      expect do
        post '/api/compositions', params: {
          player_name: 'chocotaco', hero_id: @hero1.id, map_id: @map.id
        }
      end.to change { Composition.count }.by(1)

      json = JSON.parse(response.body)
      expect(json).to have_key('composition')
      expect(json['composition']['map']['name']).to eq(@map.name)
    end

    it 'creates a new player for new name' do
      sign_in @user

      expect do
        post '/api/compositions', params: {
          player_name: 'chocotaco', hero_id: @hero1.id, map_id: @map.id
        }
      end.to change { Player.count }.by(1)

      json = JSON.parse(response.body)
      expect(json).to have_key('composition')
      expect(json['composition']['players'][0]['name']).to eq('chocotaco')
    end

    it 'reuses existing player' do
      sign_in @user
      player = create(:player)

      expect do
        post '/api/compositions', params: {
          player_name: player.name, hero_id: @hero1.id, map_id: @map.id
        }
      end.not_to change { Player.count }

      json = JSON.parse(response.body)
      expect(json).to have_key('composition')
      expect(json['composition']['players'][0]['name']).to eq(player.name)
    end

    it 'creates a new player-hero for new combination' do
      sign_in @user

      expect do
        post '/api/compositions', params: {
          player_name: 'chocotaco', hero_id: @hero1.id, map_id: @map.id
        }
      end.to change { PlayerHero.count }.by(1)

      json = JSON.parse(response.body)
      expect(json).to have_key('composition')
      expect(json['composition']['players'][0]['name']).to eq('chocotaco')

      expect(json['composition']['players'][0]['heroes'][0]['name']).to eq(@hero1.name)
    end

    it 'reuses an existing player-hero combination' do
      sign_in @user
      player = create(:player)
      player_hero = create(:player_hero, player: player, hero: @hero1)

      expect do
        post '/api/compositions', params: {
          player_name: player.name, hero_id: @hero1.id, map_id: @map.id
        }
      end.not_to change { PlayerHero.count }

      json = JSON.parse(response.body)
      expect(json).to have_key('composition')
      expect(json['composition']['players'][0]['name']).to eq(player.name)

      expect(json['composition']['players'][0]['heroes'][0]['name']).to eq(@hero1.name)
    end

    it 'creates a new player selection' do
      sign_in @user

      expect do
        post '/api/compositions', params: {
          player_name: 'chocotaco', hero_id: @hero1.id, map_id: @map.id
        }
      end.to change { PlayerSelection.count }.by(1)

      json = JSON.parse(response.body)
      expect(json).to have_key('composition')
      expect(json['composition']['players'][0]['name']).to eq('chocotaco')

      expect(json['composition']['players'][0]['heroes'][0]['name']).to eq(@hero1.name)
      expect(json['composition']['players'][0]['heroes'][0]['selected']).to eq(true)
    end

    it 'no-op for existing player selection' do
      sign_in @user

      player = create(:player)
      player_hero = create(:player_hero, player: player, hero: @hero1)
      composition = create(:composition, user: @user, map: @map)
      player_selection = create(:player_selection, composition: composition,
                                player_hero: player_hero)

      expect do
        post '/api/compositions', params: {
          player_name: player.name, hero_id: @hero1.id, map_id: @map.id,
          composition_id: composition.id
        }
      end.not_to change { PlayerSelection.count }

      json = JSON.parse(response.body)
      expect(json).to have_key('composition')
      expect(json['composition']['players'][0]['name']).to eq(player.name)

      expect(json['composition']['players'][0]['heroes'][0]['name']).to eq(@hero1.name)
      expect(json['composition']['players'][0]['heroes'][0]['selected']).to eq(true)
    end
  end

  describe 'GET new' do
    it 'loads successfully' do
      get '/api/compositions/new'
      expect(response).to be_success
    end

    it 'includes player names' do
      get '/api/compositions/new'
      expect(response.body).to include('Player 1')
      expect(response.body).to include('Player 6')
    end

    it 'includes map details' do
      get '/api/compositions/new'
      expect(response.body).to include(@map.name)
      expect(response.body).to include(@map.map_type)
      expect(response.body).to include(@map_segment.name)
    end

    it 'includes heroes with confidence values for each player' do
      get '/api/compositions/new'

      json = JSON.parse(response.body)
      expect(json).to have_key('composition')
      expect(json['composition']).to have_key('players')

      players = json['composition']['players']
      expect(players.length).to eq(6)

      players.each do |player_json|
        expect(player_json).to have_key('heroes')
        expect(player_json['heroes'].length).to eq(2)

        expect(player_json['heroes'][0]['name']).to eq(@hero1.name)
        expect(player_json['heroes'][1]['name']).to eq(@hero2.name)

        expect(player_json['heroes'][0]['confidence']).to eq(0)
        expect(player_json['heroes'][1]['confidence']).to eq(0)
      end
    end
  end
end
