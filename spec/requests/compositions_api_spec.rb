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
    it 'returns new composition info for authenticated user' do
      sign_in @user
      post '/api/compositions', params: {
        player_name: 'chocotaco', hero_id: @hero1.id,
        map_segment_id: @map_segment.id
      }

      json = JSON.parse(response.body)
      expect(json).to have_key('composition')
      expect(json['composition']['map']['name']).to eq(@map.name)
    end

    it 'returns new player info for authenticated user' do
      sign_in @user
      post '/api/compositions', params: {
        player_name: 'chocotaco', hero_id: @hero1.id,
        map_segment_id: @map_segment.id
      }

      json = JSON.parse(response.body)
      expect(json).to have_key('composition')
      expect(json['composition']['players'][0]['name']).to eq('chocotaco')
    end

    it 'returns existing player info for authenticated user' do
      sign_in @user
      player = create(:player, creator: @user)

      post '/api/compositions', params: {
        player_name: player.name, hero_id: @hero1.id,
        map_segment_id: @map_segment.id
      }

      json = JSON.parse(response.body)
      expect(json).to have_key('composition')
      expect(json['composition']['players'][0]['name']).to eq(player.name)
    end

    it 'returns new player-hero info for new combination for auth user' do
      sign_in @user
      post '/api/compositions', params: {
        player_name: 'chocotaco', hero_id: @hero1.id,
        map_segment_id: @map_segment.id
      }

      json = JSON.parse(response.body)
      expect(json).to have_key('composition')
      expect(json['composition']['players'][0]['name']).to eq('chocotaco')

      expect(json['composition']['players'][0]['heroes'][0]['name']).to eq(@hero1.name)
    end

    it 'returns existing player-hero combination for auth user' do
      sign_in @user
      player = create(:player, creator: @user)
      player_hero = create(:player_hero, player: player, hero: @hero1)

      post '/api/compositions', params: {
        player_name: player.name, hero_id: @hero1.id,
        map_segment_id: @map_segment.id
      }

      json = JSON.parse(response.body)
      expect(json).to have_key('composition')

      player_json = json['composition']['players'].detect do |pj|
        pj['name'] == player.name
      end
      expect(player_json).not_to be_nil
      expect(player_json['heroes'].length).to eq(2)

      selected_json = player_json['heroes'].detect do |sj|
        sj['mapSegmentID'] != nil
      end
      expect(selected_json).not_to be_nil
      expect(selected_json['name']).to eq(@hero1.name)
      expect(selected_json['mapSegmentID']).to eq(@map_segment.id)
    end

    it 'returns new player selection for authenticated user' do
      sign_in @user

      expect do
        post '/api/compositions', params: {
          player_name: 'chocotaco', hero_id: @hero1.id,
          map_segment_id: @map_segment.id
        }
      end.to change { PlayerSelection.count }.by(1)

      json = JSON.parse(response.body)
      expect(json).to have_key('composition')
      expect(json['composition']['players'][0]['name']).to eq('chocotaco')

      expect(json['composition']['players'][0]['heroes'][0]['name']).to eq(@hero1.name)
    end

    it 'no-op for existing player selection for authenticated user' do
      sign_in @user

      player = create(:player, creator: @user)
      player_hero = create(:player_hero, player: player, hero: @hero1)
      composition = create(:composition, user: @user, map: @map)
      player_selection = create(:player_selection, composition: composition,
                                player_hero: player_hero,
                                map_segment: @map_segment)

      post '/api/compositions', params: {
        player_name: player.name, hero_id: @hero1.id,
        composition_id: composition.id, map_segment_id: @map_segment.id
      }

      json = JSON.parse(response.body)
      expect(json).to have_key('composition')
      expect(json['composition']['players'][0]['name']).to eq(player.name)

      player_json = json['composition']['players'].detect do |pj|
        pj['name'] == player.name
      end
      expect(player_json).not_to be_nil
      expect(player_json['heroes'].length).to eq(2)

      selected_json = player_json['heroes'].detect do |sj|
        sj['mapSegmentID'] != nil
      end
      expect(selected_json).not_to be_nil
      expect(selected_json['name']).to eq(@hero1.name)
      expect(selected_json['mapSegmentID']).to eq(@map_segment.id)
    end
  end

  describe 'GET last_composition' do
    it 'loads successfully' do
      get '/api/composition/last'
      expect(response).to be_success
    end

    it 'includes player names' do
      get '/api/composition/last'
      expect(response.body).to include('Player 1')
      expect(response.body).to include('Player 6')
    end

    it 'includes map details' do
      get '/api/composition/last'
      expect(response.body).to include(@map.name)
      expect(response.body).to include(@map.map_type)
      expect(response.body).to include(@map_segment.name)
    end

    it 'includes heroes with confidence values for each player' do
      get '/api/composition/last'

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
