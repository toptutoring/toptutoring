FactoryGirl.define do
  factory :director_user, class: User do
    name          { "Director" }
    email         { "director@test.com" }
    password      { "password" }
    roles         { ["tutor", "director"] }
    auth_uid      { "xxx-xxx" }
    access_token  { "xxx-xxx" }
    refresh_token { "xxx-xxx" }
    tutor_info    { FactoryGirl.create(:tutor_info) }
  end
end
