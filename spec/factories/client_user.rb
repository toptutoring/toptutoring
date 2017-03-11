FactoryGirl.define do
  factory :client_user, class: User do
    name         { "Client" }
    email        { "client@test.com" }
    password     { "password" }
    roles        { "client" }
    access_state { "enabled" }
  end
end
