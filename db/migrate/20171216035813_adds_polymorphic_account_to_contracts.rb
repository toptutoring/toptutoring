class AddsPolymorphicAccountToContracts < ActiveRecord::Migration[5.1]
  class Contract < ApplicationRecord
    belongs_to :account, polymorphic: true
  end

  def up
    add_reference :contracts, :account, polymorphic: true, index: true
    migrate_contract_data
    remove_reference :contracts, :tutor_account
  end

  def down
    add_reference :contracts, :tutor_account
    revert_contract_data
    remove_reference :contracts, :account, polymorphic: true
  end

  private

  def migrate_contract_data
    Contract.reset_column_information
    create_contracts_for_accounts(ContractorAccount)
    create_contracts_for_accounts(TutorAccount)
  end

  def create_contracts_for_accounts(klass)
    klass.all.find_each do |account|
      contract = find_or_build_contract(account, klass)
      contract.account = account
      if contract.save
        STDOUT.puts "Contract created for #{klass} ##{account.id}."
      else
        STDOUT.puts "Failed to create contract for #{klass} ##{account.id}."
      end
    end
  end

  def find_or_build_contract(account, klass)
    return Contract.new if klass == ContractorAccount
    Contract.find_by(tutor_account_id: account.id)
  end

  def revert_contract_data
    Contract.reset_column_information
    Contract.all.find_each do |contract|
      if contract.account_type == "ContractorAccount"
        destroy_contract(contract)
      else
        revert_contract(contract)
      end
    end
  end

  def destroy_contract(contract)
    if contract.destroy
      STDOUT.puts "Contract destroyed ##{contract.id}."
    else
      STDOUT.puts "Failed to destroy contract ##{contract.id}."
    end
  end

  def revert_contract(contract)
    contract.tutor_account_id = contract.account_id
    if contract.save
      STDOUT.puts "Contract data reverted for ##{contract.id}."
    else
      STDOUT.puts "Failed to revert contract data for ##{contract.id}."
    end
  end
end
