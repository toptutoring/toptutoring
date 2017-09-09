FactoryGirl.define do
  factory :signup do
    subject  { "Math" }
    student  { false }

    trait :as_student do
      student { true }
    end
  end
end
