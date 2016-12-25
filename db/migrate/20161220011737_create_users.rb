class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.timestamps null: false
      t.string :name, null: false
      t.string :email, null: false
      t.string :encrypted_password, limit: 128, null: false
      t.string :confirmation_token, limit: 128
      t.string :remember_token, limit: 128, null: false
      t.string :phone_number
      t.string :customer_id
      t.string :auth_provider
      t.string :auth_uid
      t.string :access_token
      t.string :refresh_token
      t.integer :token_expires_at
    end

    add_index :users, :email
    add_index :users, :remember_token
  end
end
