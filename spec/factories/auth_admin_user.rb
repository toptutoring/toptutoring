FactoryGirl.define do
  factory :auth_admin_user, class: User do
    name             { "Admin" }
    email            { "admin@example.com" }
    password         { "password" }
    roles            { "admin" }
    access_token     { "QDNYpjlWQJyvtgxqj2LYcCNlJUVdISlcdUPwsW83ueXEIuuu7v" }
    refresh_token    { "TQ9z9qBMBMEhSPx4PE3shQ1v5uDN0jxO1zHqn7EtrXRb8bjCr5" }
    token_expires_at { Time.now + 1 }
    auth_uid         { ENV.fetch("DWOLLA_TEST_ADMIN_AUTH_UID") }
  end
end
