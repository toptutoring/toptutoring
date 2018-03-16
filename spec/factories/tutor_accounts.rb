FactoryBot.define do
  factory :tutor_account do
    user { FactoryBot.create(:tutor_user) }
    publish { false }
    after(:create) do |account, _|
      account.create_contract(hourly_rate_cents: 15_00)
    end
  end
end
