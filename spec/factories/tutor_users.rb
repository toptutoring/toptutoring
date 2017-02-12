FactoryGirl.define do
  factory :tutor_user, class: User do
    name          { "Tutor" }
    email         { "tutor@test.com" }
    password      { "password" }
    auth_uid      { "xxx-xxx" }
    access_token  { "xxx-xxx" }
    refresh_token { "xxx-xxx" }
    tutor         { FactoryGirl.create(:tutor) }
    balance       { 10 }
  end
end
