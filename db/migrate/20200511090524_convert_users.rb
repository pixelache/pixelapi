class ConvertUsers < ActiveRecord::Migration[6.0]
  def change
    remove_column :users, :provider
    add_column :users, :provider, :string, null: false, default: 'email'
    remove_column :users, :uid
    add_column :users, :uid, :string, default: ''
    add_column :users, :tokens, :text
    User.find_each do |user|
      if user.uid.blank?
        user.uid = user.email
        user.provider = 'email'
        if user.username.blank?
          user.username = user.email
        end
        user.save!
      end
    end
    change_column :users, :uid, :string, null: false
    add_index :users, [:uid, :provider],     :unique => true
  end
end
