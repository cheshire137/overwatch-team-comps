class AddCompositionsSlug < ActiveRecord::Migration[5.0]
  def change
    add_column :compositions, :slug, :string
    add_index :compositions, :slug, unique: true
  end
end
