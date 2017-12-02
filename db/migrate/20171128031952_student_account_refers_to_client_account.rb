class StudentAccountRefersToClientAccount < ActiveRecord::Migration[5.1]
  class User < ApplicationRecord
    has_one :client_account
  end

  class ClientAccount < ApplicationRecord
    belongs_to :user
  end

  class StudentAccount < ApplicationRecord
    belongs_to :client, class_name: "User", foreign_key: :client_id
    belongs_to :client_account
  end

  def up
    add_reference :student_accounts, :client_account
    add_client_account_to_student_account
    remove_column :student_accounts, :client_id
  end

  def down
    add_column :student_accounts, :client_id, :integer
    restore_client_id_to_student_account
    remove_reference :student_accounts, :client_account
  end

  def add_client_account_to_student_account
    StudentAccount.reset_column_information
    StudentAccount.all.find_each do |account|
      account.update(client_account: account.client.client_account)
    end
  end

  def restore_client_id_to_student_account
    StudentAccount.reset_column_information
    StudentAccount.all.find_each do |account|
      account.update(client: account.client_account.user)
    end
  end
end
