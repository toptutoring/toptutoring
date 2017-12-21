FactoryBot.define do
  factory :engagement do
    subject       { FactoryBot.create(:subject) }
    state         { "active" }
    tutor_account                 { FactoryBot.create(:tutor_user).tutor_account }
    client_account                { FactoryBot.create(:client_user).client_account }
    student_account               { FactoryBot.create(:student_user).student_account }
  end
end
