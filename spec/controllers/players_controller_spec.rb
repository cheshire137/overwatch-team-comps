require 'rails_helper'

RSpec.describe PlayersController, type: :controller do
  before(:each) do
    @anon_user = create(:anonymous_user)
    @map = create(:map)
  end

  context 'POST create' do
    it 'creates a new player and composition for anonymous user' do
      expect do
        post :create, params: {
          name: 'coolCats', map_id: @map.id, format: :json
        }
      end.to change { @anon_user.created_players.count }.by(1)
      expect(response).to be_success

      player = @anon_user.created_players.last
      expect(player.name).to eq('coolCats')

      composition = @anon_user.compositions.last
      expect(composition).not_to be_nil
      expect(composition.map).to eq(@map)
    end
  end
end
