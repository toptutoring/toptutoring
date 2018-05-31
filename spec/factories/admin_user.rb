FactoryBot.define do
  factory :admin_user, class: User do
    first_name       { "AdminName" }
    last_name        { "AdminLastName" }
    phone_number     { "510-555-5555" }
    sequence(:email) { |n| "auth_admin#{n}@example.com" }
    password         { "password" }
    roles            { Role.where(name: 'admin') }
    access_token     { "xxx-xxx" }
    refresh_token    { "xxx-xxx" }
    token_expires_at { Time.now + 60 }
    auth_uid         { ENV.fetch("DWOLLA_DEV_ADMIN_AUTH_UID") }
  end
end
