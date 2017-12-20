FactoryBot.define do
  factory :contractor_account do
    user { FactoryBot.create(:contractor_user) }

    after(:create) do |account, _|
      account.create_contract
    end
  end
end
