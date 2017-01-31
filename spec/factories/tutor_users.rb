FactoryGirl.define do
  factory :tutor_user, class: User do
    name     { "Tutor" }
    email    { "tutor@test.com" }
    password { "password" }
    auth_uid { "xxx-xxx" }
    tutor    { FactoryGirl.create(:tutor) }
  end
end
