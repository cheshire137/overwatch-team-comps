class CreatePlayerSelections < ActiveRecord::Migration[5.0]
  def change
    create_table :player_selections do |t|
      t.references :player, null: false
      t.references :hero, null: false
      t.string :role
      t.references :composition, null: false
      t.timestamps
    end
  end
end
