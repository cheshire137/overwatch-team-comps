class AddMapsSlug < ActiveRecord::Migration[5.0]
  def change
    add_column :maps, :slug, :string
    add_index :maps, :slug, unique: true
  end
end
