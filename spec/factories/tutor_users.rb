FactoryGirl.define do
  factory :tutor_user, class: User do
    name          { "Tutor" }
    email         { "tutor@test.com" }
    password      { "password" }
    roles         { "tutor" }
    auth_uid      { "xxx-xxx" }
    access_token  { "xxx-xxx" }
    refresh_token { "xxx-xxx" }
    tutor_info    { FactoryGirl.create(:tutor_info) }
    balance       { 10 }
    access_state  { "enabled" }
  end
end
