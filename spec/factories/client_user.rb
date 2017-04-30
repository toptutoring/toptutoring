FactoryGirl.define do
  factory :client_user, class: User do
    name          { "Client" }
    sequence(:email) { |n| "client_#{n}@test.com" }
    password      { "password" }
    roles         { "client" }
    access_state  { "enabled" }
    client_info   { FactoryGirl.create(:client_info) }
    customer_id   { "xxx" }
    academic_rate     { 20 }
    test_prep_rate    { 20 }
    academic_credit   { 20 }
    test_prep_credit  { 20 }
  end
end
