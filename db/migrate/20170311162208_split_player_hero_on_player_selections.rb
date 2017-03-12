class SplitPlayerHeroOnPlayerSelections < ActiveRecord::Migration[5.0]
  def up
    remove_column :player_selections, :player_hero_id

    add_column :player_selections, :player_id, :integer, null: false
    add_index :player_selections, :player_id

    add_column :player_selections, :hero_id, :integer, null: false
    add_index :player_selections, :hero_id

    add_index :player_selections, [:map_segment_id, :composition_id, :player_id],
      unique: true, name: 'idx_player_selections_unique_combo'
  end

  def down
    remove_column :player_selections, :player_id
    remove_column :player_selections, :hero_id

    add_column :player_selections, :player_hero_id, :integer, null: false
    add_index :player_selections, :player_hero_id
    add_index :player_selections, [:map_segment_id, :composition_id, :player_hero_id],
      unique: true, name: 'idx_player_selections_unique_combo'
  end
end
