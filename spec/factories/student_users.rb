FactoryGirl.define do
  factory :student_user, class: User do
    name                  { "Student" }
    email                 { "student@example.com" }
    password              { "password" }
    roles                 { "student" }
    student_info          { FactoryGirl.create(:student_info) }
    access_state          { "enabled" }
    client                { FactoryGirl.create(:client_user) }
  end
end
