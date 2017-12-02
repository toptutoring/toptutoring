class CreateStudentAccounts < ActiveRecord::Migration[5.1]
  class StudentAccount < ApplicationRecord
    belongs_to :user
    belongs_to :client, class_name: "User", foreign_key: :client_id
  end

  class Engagement < ApplicationRecord
    belongs_to :client, class_name: "User", foreign_key: "client_id"
    belongs_to :student, class_name: "User", foreign_key: "student_id"
  end

  def up
    create_table :student_accounts do |t|
      t.references :user
      t.integer :client_id
      t.string :name

      t.timestamps
    end

    create_student_accounts_from_engagements
  end

  def down
    drop_table :student_accounts
  end

  def create_student_accounts_from_engagements
    Engagement.all.find_each do |engagement|
      StudentAccount.where(name: engagement.student_name, client: engagement.client, user: engagement.student).first_or_create
    end
  end
end
