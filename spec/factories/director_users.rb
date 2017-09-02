FactoryGirl.define do
  factory :director_user, class: User do
    name          { "Director" }
    email         { "director@example.com" }
    password      { "password" }
    roles         { "director" }
    auth_uid      { ENV.fetch('DWOLLA_DEV_TUTOR_AUTH_UID') }
    access_token  { "xxx-xxx" }
    refresh_token { "xxx-xxx" }
    contract      { FactoryGirl.create(:contract) }
    access_state  { "enabled" }
  end
end
