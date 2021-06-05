class AddArchiveByContributorToEvents < ActiveRecord::Migration[6.1]
  def change
    add_column :events, :archive_by_contributor, :boolean, null: false, default: false
  end
end
