FactoryGirl.define do
  factory :parent_user, class: User do
    name     { "Parent" }
    email    { "parent@test.com" }
    password { "password" }
    student  { FactoryGirl.create(:student) }
  end
end
