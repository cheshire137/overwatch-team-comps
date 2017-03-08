class MakeCompositionNameNonNullable < ActiveRecord::Migration[5.0]
  def change
    change_column_null :compositions, :name, false
  end
end
