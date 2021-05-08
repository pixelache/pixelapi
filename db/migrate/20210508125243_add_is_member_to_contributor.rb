class AddIsMemberToContributor < ActiveRecord::Migration[6.1]
  def change
    add_column :contributors, :is_member, :boolean, null: false, default: false
  end
end
