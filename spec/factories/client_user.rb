FactoryGirl.define do
  factory :client_user, class: User do
    name          { "Client" }
    sequence(:email) { |n| "client_#{n}@example.com" }
    password      { "password" }
    roles         { "client" }
    access_state  { "enabled" }
    client_info   { FactoryGirl.create(:client_info) }
    credit_cards  { [FactoryGirl.create(:credit_card)] }
    academic_rate     { 20 }
    test_prep_rate    { 20 }
    academic_credit   { 20 }
    test_prep_credit  { 20 }

    trait :as_student do
      client_info   { FactoryGirl.create(:client_info, :as_student) }
    end
  end
end
