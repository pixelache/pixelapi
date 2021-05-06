class CreateContributorRelations < ActiveRecord::Migration[6.1]
  def change
    create_table :contributor_relations do |t|
      t.references :contributor, null: false, foreign_key: true
      t.references :relation, polymorphic: true, null: false

      t.timestamps
    end
  end
end
