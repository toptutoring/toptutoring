FactoryGirl.define do
  factory :tutor do
    subject       { "Math" }
    academic_type { "Test Prep" }
    hourly_rate   { 20 }
  end
end
