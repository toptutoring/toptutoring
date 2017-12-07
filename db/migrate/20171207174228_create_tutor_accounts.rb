class CreateTutorAccounts < ActiveRecord::Migration[5.1]
  class User < ApplicationRecord
    has_one :tutor_account
  end

  class TutorAccount < ApplicationRecord
    belongs_to :user
  end

  def up
    create_table :tutor_accounts do |t|
      t.references :user

      t.timestamps
    end

    User.all.find_each do |user|
      user.create_tutor_account
      STDOUT.puts "Created a tutor account for user ##{user.id}"
    end
  end

  def down
    drop_table :tutor_accounts
  end
end
