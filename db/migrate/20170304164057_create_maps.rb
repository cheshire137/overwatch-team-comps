class CreateMaps < ActiveRecord::Migration[5.0]
  def change
    create_table :maps do |t|
      t.string :name, null: false
      t.string :map_type
      t.timestamps
    end
  end
end
