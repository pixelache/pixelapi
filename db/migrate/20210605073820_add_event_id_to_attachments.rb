class AddEventIdToAttachments < ActiveRecord::Migration[6.1]
  def change
    add_column :attachments, :event_id, :integer
  end
end
