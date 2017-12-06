FactoryGirl.define do
  factory :signup do
    subject  { Subject.first_or_create(name: 'Math') }
    student  { false }

    trait :as_student do
      student { true }
    end
  end
end
