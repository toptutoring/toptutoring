FactoryGirl.define do
  factory :client_info do
    subject  { "Math" }
    student  { false }

    trait :as_student do
      student { true }
    end
  end
end
