FactoryBot.define do
  factory :admin_user, class: User do
    first_name        { "AdminName" }
    last_name         { "AdminLastName" }
    phone_number      { "510-555-5555" }
    sequence(:email)  { |n| "admin#{n}@example.com" }
    password          { "password" }
    roles             { Role.where(name: 'admin') }
    token_expires_at  { 1524332549 }
  end
end
