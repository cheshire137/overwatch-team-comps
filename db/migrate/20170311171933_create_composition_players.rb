class CreateCompositionPlayers < ActiveRecord::Migration[5.0]
  def change
    create_table :composition_players do |t|
      t.references :composition, null: false
      t.references :player, null: false
      t.integer :position, null: false, default: 0
      t.timestamps
    end
  end
end
