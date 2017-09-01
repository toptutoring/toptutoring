FactoryGirl.define do
  factory :auth_admin_user, class: User do
    name             { "Admin" }
    sequence(:email) { |n| "auth_admin#{n}@example.com" }
    password         { "password" }
    roles            { "admin" }
    access_token     { "xxx-xxx" }
    refresh_token    { "xxx-xxx" }
    token_expires_at { Time.now + 1 }
    auth_uid         { ENV.fetch("DWOLLA_DEV_ADMIN_AUTH_UID") }
  end
end
