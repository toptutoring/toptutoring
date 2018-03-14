FactoryBot.define do
  factory :test_score do
    score "1450"
    badge nil
    subject  { FactoryBot.create(:subject, academic_type: "test_prep") }
    tutor_account { FactoryBot.create(:tutor_user).tutor_account }
  end
end
