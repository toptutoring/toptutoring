FactoryGirl.define do
  factory :director_user, class: User do
    name     { "Director" }
    email    { "director@test.com" }
    password { "password" }
    auth_uid { "xxx-xxx" }
    tutor    { FactoryGirl.create(:tutor, director: true) }
  end
end
