require 'rails_helper'

RSpec.describe PlayersController, type: :controller do
  before(:each) do
    @anon_user = create(:anonymous_user)
    @user = create(:user)
    @map = create(:map)
  end

  context 'PUT update' do
    it 'updates existing player owned by the user' do
      player = create(:player, creator: @user)
      composition = create(:composition, user: @user)

      sign_in @user
      expect do
        put :update, params: {
          format: :json, id: player.id, name: 'new name',
          battletag: 'new battletag', composition_id: composition.id
        }
      end.not_to change { Player.count }

      expect(response).to be_success
      expect(player.reload.name).to eq('new name')
      expect(player.battletag).to eq('new battletag')
    end

    it "will not update another user's player" do
      player = create(:player, name: 'old name', battletag: 'old battletag')
      composition = create(:composition, user: @user)

      sign_in @user
      expect do
        put :update, params: {
          format: :json, id: player.id, name: 'new name',
          battletag: 'new battletag', composition_id: composition.id
        }
      end.not_to change { Player.count }

      expect(response).to have_http_status(404)
      expect(player.reload.name).to eq('old name')
      expect(player.battletag).to eq('old battletag')
    end
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
