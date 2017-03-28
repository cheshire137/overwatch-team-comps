class AddPlatformRegionToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :platform, :string, limit: 3
    add_column :users, :region, :string, limit: 6
  end
end
