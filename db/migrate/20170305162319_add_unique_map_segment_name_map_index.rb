class AddUniqueMapSegmentNameMapIndex < ActiveRecord::Migration[5.0]
  def change
    add_index :map_segments, [:name, :map_id], unique: true
  end
end
