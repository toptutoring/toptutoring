FactoryGirl.define do
  factory :student_user, class: User do
    name         { "Student" }
    email        { "student@test.com" }
    password     { "password" }
    roles        { "student" }
    student_info { FactoryGirl.create(:student_info) }
    access_state { "enabled" }
    engagement   { FactoryGirl.create(:engagement) }
    client       { FactoryGirl.create(:client_user)}
  end
end
