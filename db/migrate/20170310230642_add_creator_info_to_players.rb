class AddCreatorInfoToPlayers < ActiveRecord::Migration[5.0]
  def change
    add_column :players, :creator_id, :integer, null: false
    add_index :players, :creator_id

    add_column :players, :creator_session_id, :string, limit: 32
  end
end
