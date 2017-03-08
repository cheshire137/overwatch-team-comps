class AddVideoUrlToCompositions < ActiveRecord::Migration[5.0]
  def change
    add_column :compositions, :video_url, :string, null: true, default: ''
    add_column :compositions, :session_id, :string, null: false, limit: 32
    change_column :compositions, :user_id, :integer, null: false
  end
end
