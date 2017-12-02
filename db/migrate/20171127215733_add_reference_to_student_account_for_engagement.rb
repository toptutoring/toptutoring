class AddReferenceToStudentAccountForEngagement < ActiveRecord::Migration[5.1]
  class StudentAccount < ApplicationRecord
    belongs_to :user
    belongs_to :client, class_name: "User", foreign_key: :client_id
    has_many :engagements
  end

  class Engagement < ApplicationRecord
    belongs_to :client, class_name: "User", foreign_key: :client_id
    belongs_to :student, class_name: "User", foreign_key: :student_id
    belongs_to :student_account
  end

  def up
    add_reference :engagements, :student_account

    add_student_accounts_to_engagements

    remove_column :engagements, :student_name
    remove_column :engagements, :student_id
  end

  def down
    add_reference :engagements, :student_id
    add_column :engagements, :student_name, :string

    remove_student_accounts_from_engagements

    remove_reference :engagements, :student_account
  end

  def add_student_accounts_to_engagements
    Engagement.reset_column_information
    Engagement.all.find_each do |engagement|
      student_account = StudentAccount
                        .find_by(name: engagement.student_name,
                                 client: engagement.client,
                                 user: engagement.student)
      engagement.update(student_account: student_account)
    end
  end

  def remove_student_accounts_from_engagements
    Engagement.reset_column_information
    Engagement.all.find_each do |engagement|
      student = engagement.student_account.user
      name = engagement.student_account.name
      engagement.update(student_name: name, student: student)
    end
  end
end
