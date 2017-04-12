FactoryGirl.define do
  factory :client_user, class: User do
    name         { "Client" }
    sequence(:email) { |n| "client_#{n}@test.com" }
    password     { "password" }
    roles        { "client" }
    access_state { "enabled" }
    client_info  { FactoryGirl.create(:client_info) }
    customer_id  { "xxx" }
  end
end
