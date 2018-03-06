FactoryBot.define do
  factory :contractor_user, class: User do
    first_name    { "ContractorName" }
    last_name     { "ContractorLastName" }
    phone_number  { "510-555-5555" }
    sequence(:email) { |n| "contractor#{n}@example.com" }
    password      { "password" }
    roles         { Role.where(name: "contractor") }
    access_state  { "enabled" }

    after(:create) do |user, _|
      user.create_contractor_account(hourly_rate: 15)
    end
  end
end
