class AddMapSegmentIdToPlayerSelections < ActiveRecord::Migration[5.0]
  def change
    add_column :player_selections, :map_segment_id, :integer, null: false
  end
end
