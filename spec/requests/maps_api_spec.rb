require 'rails_helper'

RSpec.describe 'maps API' do
  before(:each) do
    @map = create(:map)
    @map_segment = create(:map_segment, map: @map)
  end

  describe 'GET index' do
    it 'loads successfully' do
      get '/api/maps'
      expect(response).to be_success
      expect(response.body).to include(@map.name)
      expect(response.body).to include(@map.map_type)
      expect(response.body).to include(@map_segment.name)
    end
  end
end
