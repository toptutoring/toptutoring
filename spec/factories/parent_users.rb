FactoryGirl.define do
  factory :parent_user, class: User do
    name     { "Parent" }
    email    { "parent@toptutoring.com" }
    password { "password" }
    student    { FactoryGirl.create(:student) }
  end
end
