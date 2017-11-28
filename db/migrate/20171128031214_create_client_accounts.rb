class CreateClientAccounts < ActiveRecord::Migration[5.1]
  class ClientAccount < ApplicationRecord
    belongs_to :user
  end

  def up
    create_table :client_accounts do |t|
      t.references :user, foreign_key: true

      t.timestamps
    end

    add_client_accounts_to_client_users
  end

  def down
    drop_table :client_accounts
  end

  def add_client_accounts_to_client_users
    User.clients.find_each do |client|
      ClientAccount.create(user: client)
    end
  end
end
