FactoryGirl.define do
  factory :director_user, class: User do
    name          { "Director" }
    phone_number  { "555-5555" }
    email         { "director@example.com" }
    password      { "password" }
    roles         { Role.where(name: 'director') }
    auth_uid      { ENV.fetch('DWOLLA_DEV_TUTOR_AUTH_UID') }
    access_token  { "xxx-xxx" }
    refresh_token { "xxx-xxx" }
    contract      { FactoryGirl.create(:contract) }
    access_state  { "enabled" }

    after(:create) do |user, _|
      user.create_tutor_account
    end
  end
end
