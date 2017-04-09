class AddAllowDuplicatesToCompositions < ActiveRecord::Migration[5.0]
  def change
    add_column :compositions, :allow_duplicates, :boolean, default: false, null: false
  end
end
