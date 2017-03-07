require 'rails_helper'

RSpec.describe 'compositions API' do
  before(:each) do
    @map = create(:map)
    @map_segment = create(:map_segment, map: @map)
  end

  describe 'GET index' do
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
  end
end
