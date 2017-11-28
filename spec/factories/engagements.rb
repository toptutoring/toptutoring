FactoryGirl.define do
  factory :engagement do
    subject       { FactoryGirl.create(:subject, academic_type: 'academic') }
    state         { "active" }
    tutor                 { FactoryGirl.create(:tutor_user) }
    client                { FactoryGirl.create(:client_user) }
    student_account               { FactoryGirl.create(:student_account) }
  end
end
