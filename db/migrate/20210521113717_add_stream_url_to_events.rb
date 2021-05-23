class AddStreamUrlToEvents < ActiveRecord::Migration[6.1]
  def change
    add_column :events, :stream_url, :string
  end
end
