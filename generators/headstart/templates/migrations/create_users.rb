class HeadstartCreateUsers < ActiveRecord::Migration
  def self.up
    create_table(:users) do |t|
      t.string   :email,                :limit => 100
      t.string   :first_name,           :limit => 50
      t.string   :last_name,            :limit => 50
      t.string   :role,                 :limit => 50
      t.string   :encrypted_password,   :limit => 128
      t.string   :salt,                 :limit => 128
      t.string   :remember_token,       :limit => 128
      t.string   :facebook_uid,         :limit => 50
      t.string   :password_reset_token, :limit => 128
      t.string   :confirmation_token, :limit => 128
      t.boolean  :email_confirmed, :default => false, :null => false
      t.boolean  :email_confirmation_sent_at, :datetime
      
      t.string   :avatar_file_name
      t.string   :avatar_content_type
      t.integer  :avatar_file_size
      t.datetime :avatar_updated_at
      
      t.timestamps
    end

    add_index :users, :email
    add_index :users, :remember_token
    add_index :users, :facebook_uid
  end

  def self.down
    drop_table :users
  end
end
