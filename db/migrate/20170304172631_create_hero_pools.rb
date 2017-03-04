class CreateHeroPools < ActiveRecord::Migration[5.0]
  def change
    create_table :hero_pools do |t|
      t.references :player, null: false
      t.references :hero, null: false
      t.integer :confidence, null: false, default: 0
      t.timestamps
    end
  end
end
