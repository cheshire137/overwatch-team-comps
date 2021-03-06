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

    it 'returns existing player info for authenticated user' do
      sign_in @user
      player = create(:player, creator: @user)

      post '/api/compositions', params: {
        hero_id: @hero1.id, map_segment_id: @map_segment.id, player_id: player.id
      }

      json = JSON.parse(response.body)
      expect(json).to have_key('composition')
      expect(json['composition']['players'][0]['name']).to eq(player.name)
    end

    it 'includes players created by the authenticated user' do
      player = create(:player, creator: @user)

      sign_in @user

      post '/api/compositions', params: {
        player_id: player.id, hero_id: @hero1.id,
        map_segment_id: @map_segment.id
      }

      json = JSON.parse(response.body)
      expect(json['composition']).to have_key('availablePlayers')

      avail_players = json['composition']['availablePlayers']
      expect(avail_players.size).to eq(1)
      expect(avail_players[0]['id']).to eq(player.id)
      expect(avail_players[0]['name']).to eq(player.name)
    end

    it 'no-op for existing player selection for authenticated user' do
      sign_in @user

      player = create(:player, creator: @user)
      composition = create(:composition, user: @user, map: @map)
      comp_player = create(:composition_player, player: player,
                           composition: composition)
      player_selection = create(:player_selection, composition_player: comp_player,
                                hero: @hero1, map_segment: @map_segment)

      post '/api/compositions', params: {
        hero_id: @hero1.id, composition_id: composition.id,
        map_segment_id: @map_segment.id, player_id: player.id,
        player_position: comp_player.position
      }

      json = JSON.parse(response.body)
      expect(json).to have_key('composition'), response.body
      expect(json['composition']['players'][0]['name']).to eq(player.name)

      player_json = json['composition']['players'].detect do |pj|
        pj['name'] == player.name
      end
      expect(player_json).not_to be_nil

      expect(json['composition']['selections'].length).to eq(1)
      expect(json['composition']['selections']).to have_key(player.id.to_s)
      expect(json['composition']['selections'][player.id.to_s]).
        to have_key(@map_segment.id.to_s)
      expect(json['composition']['selections'][player.id.to_s][@map_segment.id.to_s]).
        to eq(@hero1.id)
    end
  end

  describe 'GET last_composition' do
    it 'loads successfully' do
      get '/api/composition/last'
      expect(response).to be_success
    end

    it 'loads requested map' do
      map = create(:map)
      get "/api/composition/last?map_id=#{map.id}"
      expect(response).to be_success
      expect(response.body).to include(map.id.to_s)
      expect(response.body).to include('"' + map.name + '"')
    end

    it 'includes names of players created by the user' do
      player = create(:player, creator: @user)

      sign_in @user

      get '/api/composition/last'
      expect(response.body).to include('"' + player.name + '"')
    end

    it 'includes map details' do
      get '/api/composition/last'
      expect(response.body).to include(@map.name)
      expect(response.body).to include(@map.map_type)
      expect(response.body).to include(@map_segment.name)
    end

    it 'includes players created by the authenticated user' do
      player = create(:player, creator: @user)

      sign_in @user
      get '/api/composition/last'

      json = JSON.parse(response.body)
      expect(json['composition']).to have_key('availablePlayers')

      avail_players = json['composition']['availablePlayers']
      expect(avail_players.size).to eq(1)
      expect(avail_players[0]['id']).to eq(player.id)
      expect(avail_players[0]['name']).to eq(player.name)
    end
  end
end
