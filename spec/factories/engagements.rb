FactoryGirl.define do
  factory :engagement do
    subject       { FactoryGirl.create(:subject) }
    state         { "active" }
    tutor                 { FactoryGirl.create(:tutor_user) }
    client_account                { FactoryGirl.create(:client_user).client_account }
    student_account               { FactoryGirl.create(:student_user).student_account }
  end
end
