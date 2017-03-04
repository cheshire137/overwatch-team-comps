class CreateMaps < ActiveRecord::Migration[5.0]
  def change
    create_table :maps do |t|
      t.string :name
      t.string :type
      t.string :slug
      t.timestamps
    end
  end
end
