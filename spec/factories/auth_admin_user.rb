FactoryGirl.define do
  factory :auth_admin_user, class: User do
    name             { "Admin" }
    email            { "admin@example.com" }
    password         { "password" }
    roles            { "admin" }
    access_token     { "QDNYpjlWQJyvtgxqj2LYcCNlJUVdISlcdUPwsW83ueXEIuuu7v" }
    refresh_token    { "TQ9z9qBMBMEhSPx4PE3shQ1v5uDN0jxO1zHqn7EtrXRb8bjCr5" }
    token_expires_at { Time.now + 1 }
    auth_uid         { "8fb759cf-b90d-4ac8-b00e-9760bbfa1a7f" }
  end
end
