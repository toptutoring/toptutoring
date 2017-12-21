FactoryBot.define do
  factory :tutor_account do
    after(:create) do |account, _|
      account.create_contract(hourly_rate_cents: 15_00)
    end
  end
end
