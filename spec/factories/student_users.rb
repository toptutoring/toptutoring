FactoryGirl.define do
  factory :student_user, class: User do
    name         { "Student" }
    email        { "student@test.com" }
    password     { "password" }
    roles        { [:student] }
    student_info { FactoryGirl.create(:student_info) }
    access_state { "enabled" }
    assignment   { FactoryGirl.create(:assignment) }
    parent       { FactoryGirl.create(:parent_user)}
  end
end
