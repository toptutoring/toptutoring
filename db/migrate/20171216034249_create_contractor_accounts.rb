class CreateContractorAccounts < ActiveRecord::Migration[5.1]
  class TutorAccount < ApplicationRecord; end

  class ClientAccount < ApplicationRecord; end

  class ContractorAccount < ApplicationRecord
    belongs_to :user
  end

  def up
    create_table :contractor_accounts do |t|
      t.references :user, foreign_key: true
    end
    associate_contractors
    destroy_tutor_accounts_for_non_tutors
    test_number_of_accounts
  end

  def down
    drop_table :contractor_accounts
  end

  private

  def associate_contractors
    ContractorAccount.reset_column_information
    User.joins(:roles)
        .where(roles: { name: "contractor" })
        .find_each do |contractor|
      new_account = ContractorAccount.new(user: contractor)
      if new_account.save
        STDOUT.puts "Created a contractor account for user ##{contractor.id}"
      else
        STDOUT.puts "Failed to create a contractor account for user ##{contractor.id}"
      end
    end
  end

  def destroy_tutor_accounts_for_non_tutors
    ids = User.left_joins(:roles).where.not(roles: { name: "tutor" })
              .or(User.left_joins(:roles).where(roles: { id: nil })).ids
    ids -= User.tutors.ids
    STDOUT.puts "Destroying tutor accounts for users that are not tutors. Ids: #{ids.sort}."
    TutorAccount.where(user_id: ids).destroy_all
  end

  def test_number_of_accounts
    if User.clients.count != ClientAccount.count ||
       User.tutors.count != TutorAccount.count ||
       User.contractors.count != ContractorAccount.count
      raise StandardError, "Number of accounts do not match up"
    end
  end
end
