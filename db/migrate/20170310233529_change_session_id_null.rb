class ChangeSessionIdNull < ActiveRecord::Migration[5.0]
  def change
    change_column_null :compositions, :session_id, true
  end
end
