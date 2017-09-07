FactoryGirl.define do
  factory :tutor_user, class: User do
    name                { "Tutor" }
    sequence(:email) { |n| "tutor_#{n}@example.com" }
    password            { "password" }
    roles               { "tutor" }
    auth_uid            { ENV.fetch("DWOLLA_DEV_TUTOR_AUTH_UID") }
    access_token        { "xxx-xxx" }
    refresh_token       { "xxx-xxx" }
    token_expires_at { Time.now + 60 }
    contract            { FactoryGirl.create(:contract) }
    access_state        { "enabled" }
  end
end
