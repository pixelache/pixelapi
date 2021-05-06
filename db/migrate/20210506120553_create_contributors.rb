class CreateContributors < ActiveRecord::Migration[6.1]
  def change
    create_table :contributors do |t|
      t.string :name
      t.string :alphabetical_name
      t.string :website
      t.text :bio
      t.string :image
      t.string :image_content_type
      t.integer :image_file_size, limit: 8
      t.integer :image_width
      t.integer :image_height
      t.references :user, null: true, foreign_key: true
      t.integer :parent_id
      t.string :slug
      t.timestamps
    end
  end
end
