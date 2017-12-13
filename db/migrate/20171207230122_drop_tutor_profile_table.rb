class DropTutorProfileTable < ActiveRecord::Migration[5.1]
  class User < ApplicationRecord
    has_one :tutor_account
    has_many :tutor_profiles
    has_many :subjects, through: :tutor_profiles
  end

  class TutorAccount < ApplicationRecord
    has_and_belongs_to_many :subjects
    belongs_to :user
  end

  class Subject < ApplicationRecord
    has_many :tutor_profiles
    has_and_belongs_to_many :tutor_accounts
  end

  class TutorProfile < ApplicationRecord
    belongs_to :user
    belongs_to :subject
  end

  def up
    send_data_to_subject_tutor_account
    drop_table :tutor_profiles
  end

  def down
    create_table :tutor_profiles do |t|
      t.references :user
      t.references :subject
    end
    revert_data_to_tutor_profiles
  end

  private

  def send_data_to_subject_tutor_account
    TutorAccount.all.find_each do |account|
      subject_ids = account.user.subjects.ids
      account.subject_ids = subject_ids
      STDOUT.puts "Adding subject with ids #{subject_ids.join(', ')} to tutor account #{account.id}"
    end
  end

  def revert_data_to_tutor_profiles
    TutorAccount.all.find_each do |account|
      user = account.user
      subject_ids = account.subject_ids
      user.subject_ids = subject_ids
      STDOUT.puts "Adding subject with ids ##{subject_ids.join(', ')} to tutor_profile for user ##{user.id}."
    end
  end
end
