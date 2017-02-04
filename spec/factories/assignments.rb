FactoryGirl.define do
  factory :assignment do
    tutor         { FactoryGirl.create(:tutor_user) }
    student       { FactoryGirl.create(:parent_user) }
    subject       { "Math" }
    academic_type { "Test Prep" }
    hourly_rate   { 20 }
    state         { "active" }
  end
end
