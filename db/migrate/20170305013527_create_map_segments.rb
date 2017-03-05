class CreateMapSegments < ActiveRecord::Migration[5.0]
  def change
    create_table :map_segments do |t|
      t.references :map, null: false
      t.string :name, null: false
      t.timestamps
    end
  end
end
