class CreatePlayers < ActiveRecord::Migration[5.0]
  def change
    create_table :players do |t|
      t.string :name, null: false
      t.string :battlenet
      t.references :user
      t.timestamps
    end
  end
end
