class CreateCompositions < ActiveRecord::Migration[5.0]
  def change
    create_table :compositions do |t|
      t.string :name
      t.text :notes
      t.references :map, null: false
      t.timestamps
    end
  end
end
