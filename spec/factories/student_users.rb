FactoryGirl.define do
  factory :student_user, class: User do
    name             { "Student" }
    sequence(:email) { |n| "student#{n}@example.com" }
    password         { "password" }
    roles            { "student" }
    access_state     { "enabled" }
    client           { FactoryGirl.create(:client_user) }
  end
end
