require 'rails_helper'

RSpec.describe 'compositions API' do
  before(:each) do
    @map = create(:map)
    @map_segment = create(:map_segment, map: @map)
    @hero1 = create(:hero, name: 'Hanzo')
    @hero2 = create(:hero, name: 'Mercy')
    @user = create(:user)
  end

  describe 'POST create' do
    it 'loads successfully for authenticated user' do
      sign_in @user
      post '/api/compositions', params: {
        player_name: 'chocotaco', hero_id: @hero1.id, map_id: @map.id
      }
      expect(response).to be_success, response.body
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
