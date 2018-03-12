FactoryBot.define do
  factory :director_user, class: User do
    first_name          { "DirectorName" }
    last_name          { "DirectorLastName" }
    phone_number  { "(510)555-5555" }
    email         { "director@example.com" }
    password      { "password" }
    roles         { Role.where(name: "director") }
    auth_uid      { ENV.fetch("DWOLLA_DEV_TUTOR_AUTH_UID") }
    access_token  { "xxx-xxx" }
    refresh_token { "xxx-xxx" }
    access_state  { "enabled" }

    after(:create) do |user, _|
      user.create_tutor_account(online_rate: 15, in_person_rate: 20)
    end
  end
end
