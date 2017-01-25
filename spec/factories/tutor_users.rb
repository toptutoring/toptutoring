FactoryGirl.define do
  factory :tutor_user, class: User do
    name     { "Tutor" }
    email    { "tutor@toptutoring.com" }
    password { "password" }
    tutor    { FactoryGirl.create(:tutor) }
  end
end
