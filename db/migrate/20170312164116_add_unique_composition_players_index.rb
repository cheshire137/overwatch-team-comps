class AddUniqueCompositionPlayersIndex < ActiveRecord::Migration[5.0]
  def up
    add_index :composition_players, [:composition_id, :player_id], unique: true
    remove_index :composition_players, :composition_id
  end

  def down
    add_index :composition_players, :composition_id
    remove_index :composition_players, [:composition_id, :player_id]
  end
end
