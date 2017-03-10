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
  end
end
