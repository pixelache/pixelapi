class CreateContributorHierarchies < ActiveRecord::Migration[6.1]
  def change
    create_table :contributor_hierarchies, id: false do |t|
      t.integer :ancestor_id, null: false
      t.integer :descendant_id, null: false
      t.integer :generations, null: false
    end

    add_index :contributor_hierarchies, [:ancestor_id, :descendant_id, :generations],
      unique: true,
      name: "contributor_anc_desc_idx"

    add_index :contributor_hierarchies, [:descendant_id],
      name: "contributor_desc_idx"
  end
end
