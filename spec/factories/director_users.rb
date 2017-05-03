FactoryGirl.define do
  factory :director_user, class: User do
    name          { "Director" }
    email         { "director@example.com" }
    password      { "password" }
    roles         { "director" }
    auth_uid      { "xxx-xxx" }
    access_token  { "xxx-xxx" }
    refresh_token { "xxx-xxx" }
    contract      { FactoryGirl.create(:contract) }
    access_state  { "enabled" }
  end
end
