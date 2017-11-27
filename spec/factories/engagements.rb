FactoryGirl.define do
  factory :engagement do
    subject       { FactoryGirl.create(:subject, academic_type: 'academic') }
    state         { "active" }
    tutor                 { FactoryGirl.create(:tutor_user) }
    client                { FactoryGirl.create(:client_user) }
    student               { FactoryGirl.create(:student_user, name: "Bobby") }
    student_name          { student.name }
  end
end
