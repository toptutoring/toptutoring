FactoryGirl.define do
  factory :assignment do
    subject       { "Math" }
    academic_type { "Test Prep" }
    hourly_rate   { 20 }
    state         { "active" }
  end
end
