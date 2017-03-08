class AddUniquePlayerSelectionsIndex < ActiveRecord::Migration[5.0]
  def change
    add_index :player_selections, [:map_segment_id, :composition_id, :player_hero_id],
      unique: true, name: 'idx_player_selections_unique_combo'
  end
end
