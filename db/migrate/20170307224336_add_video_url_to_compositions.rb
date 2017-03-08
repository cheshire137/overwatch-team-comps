class AddVideoUrlToCompositions < ActiveRecord::Migration[5.0]
  def change
    add_column :compositions, :video_url, :string, null: true, default: ''
  end
end
