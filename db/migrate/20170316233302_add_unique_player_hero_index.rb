class AddUniquePlayerHeroIndex < ActiveRecord::Migration[5.0]
  def up
    add_index :player_heroes, [:hero_id, :player_id], unique: true
    remove_index :player_heroes, :hero_id
  end

  def down
    add_index :player_heroes, :hero_id
    remove_index :player_heroes, [:hero_id, :player_id]
  end
end
