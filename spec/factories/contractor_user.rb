FactoryBot.define do
  factory :contractor_user, class: User do
    name          { "Contractor" }
    phone_number  { "555-5555" }
    sequence(:email) { |n| "contractor#{n}@example.com" }
    password      { "password" }
    roles         { Role.where(name: "contractor") }
    access_state  { "enabled" }
    academic_rate     { 20 }
    test_prep_rate    { 20 }
    academic_credit   { 20 }
    test_prep_credit  { 20 }

    after(:create) do |user, _|
      user.create_contractor_account(hourly_rate: 15)
    end
  end
end
