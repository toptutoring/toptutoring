FactoryGirl.define do
  factory :parent_user, class: User do
    name         { "Parent" }
    email        { "parent@test.com" }
    password     { "password" }
    roles         { [:parent] }
    student      { FactoryGirl.create(:student_user) }
    access_state { "enabled" }
  end
end
