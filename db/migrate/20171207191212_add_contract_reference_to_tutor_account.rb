class AddContractReferenceToTutorAccount < ActiveRecord::Migration[5.1]
  def up
    add_reference :contracts, :tutor_account
    add_tutor_account_to_contracts
    remove_reference :contracts, :user
  end

  def down
    add_reference :contracts, :user
    revert_contract_data
    remove_reference :contracts, :tutor_account
  end

  private

  def add_tutor_account_to_contracts
    Contract.reset_column_information
    Contract.all.find_each do |contract|
      contract.tutor_account_id = TutorAccount.find_by(user_id: contract.user_id).id
      if contract.save
        STDOUT.puts "Added tutor account to contract #{contract.id}"
      else
        STDOUT.puts "Failed to add tutor account to contract #{contract.id}"
      end
    end
  end

  def revert_contract_data
    Contract.reset_column_information
    Contract.all.find_each do |contract|
      contract.user_id = TutorAccount.find_by_id(contract.tutor_account_id).user_id
      if contract.save
        STDOUT.puts "Reverted contract ##{contract.id} to user ##{contract.user_id}"
      else
        STDOUT.puts "Failed to revert data for #{contract.id}"
      end
    end
  end
end
