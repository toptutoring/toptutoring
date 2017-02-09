FactoryGirl.define do
  factory :auth_admin_user, class: User do
    name             { "Admin" }
    email            { "admin@test.com" }
    password         { "password" }
    admin            { true }
    access_token     { "6mlZ2ow5vQazRhbIVLnJNcrR3OZ1Ykj6OIZxINdhQ90bCaAYAE" }
    refresh_token    { "deGkVTvFBU9mFlAT3shbi672FPQsA8VI5yw0vmbYDCRC8EjXZ0" }
    token_expires_at { Time.now + 1 }
    auth_uid         { "8fb759cf-b90d-4ac8-b00e-9760bbfa1a7f" }
  end
end
