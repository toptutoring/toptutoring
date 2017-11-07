FactoryGirl.define do
  factory :engagement do
    subject       { "Math" }
    academic_type { "Test Prep" }
    state         { "active" }
    tutor                 { FactoryGirl.create(:tutor_user) }
    client                { FactoryGirl.create(:client_user) }
    student               { FactoryGirl.create(:student_user, name: "Bobby") }
    student_name          { student.name }
  end
end
