class AddBattletagToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :battletag, :string
    rename_column :players, :battlenet, :battletag
  end
end
