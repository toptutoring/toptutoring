FactoryBot.define do
  factory :tutor_user, class: User do
    name                { "Tutor" }
    phone_number        { "(510)555-5555" }
    sequence(:email) { |n| "tutor_#{n}@example.com" }
    password            { "password" }
    roles               { Role.where(name: 'tutor') }
    auth_uid            { ENV.fetch("DWOLLA_DEV_TUTOR_AUTH_UID") }
    access_token        { "xxx-xxx" }
    refresh_token       { "xxx-xxx" }
    token_expires_at    { Time.now + 60 }
    access_state        { "enabled" }

    after(:create) do |user, _|
      user.create_tutor_account.create_contract(hourly_rate: 15)
    end
  end
end
