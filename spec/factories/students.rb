FactoryGirl.define do
  factory :student do
    subject       { "Math" }
    academic_type { "Test Prep" }
    name          { "Student" }
  end
end
