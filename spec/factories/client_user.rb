FactoryGirl.define do
  factory :client_user, class: User do
    name          { "Client" }
    sequence(:email) { |n| "client_#{n}@example.com" }
    password      { "password" }
    roles         { "client" }
    access_state  { "enabled" }
    signup   { FactoryGirl.create(:signup) }
    customer_id   { "xxx" }
    academic_rate     { 20 }
    test_prep_rate    { 20 }
    academic_credit   { 20 }
    test_prep_credit  { 20 }

    trait :as_student do
      signup   { FactoryGirl.create(:signup, :as_student) }
    end
  end
end
