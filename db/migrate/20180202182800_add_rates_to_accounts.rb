class AddRatesToAccounts < ActiveRecord::Migration[5.1]
  def change
    add_monetize :tutor_accounts, :online_rate
    add_monetize :tutor_accounts, :in_person_rate
    add_monetize :contractor_accounts, :hourly_rate

    migrate_rate_data
  end

  private

  def update_rate(klass)
    klass.reset_column_information
    klass.all.find_each do |instance|
      if yield instance
        STDOUT.puts "Updated rates for #{klass} object with id #{instance.id}."
      else
        STDOUT.puts "Failed to update rates #{klass} object with id #{instance.id}."
      end
    end
  end

  def migrate_rate_data
    update_rate(TutorAccount) do |account|
      account.online_rate_cents = account.contract.hourly_rate_cents
      account.in_person_rate_cents = account.contract.hourly_rate_cents
      account.in_person_rate_cents = 30_00 if account.user.id == 90
      account.save
    end
    update_rate(ContractorAccount) do |account|
      account.hourly_rate_cents = account.contract.hourly_rate_cents
      account.save
    end
  end
end
