FactoryGirl.define do
  factory :engagement do
    subject       { "Math" }
    academic_type { "Test Prep" }
    state         { "active" }
  end
end
