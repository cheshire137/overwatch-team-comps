class AddUniqueMapNameIndex < ActiveRecord::Migration[5.0]
  def change
    add_index :maps, :name, unique: true
  end
end
