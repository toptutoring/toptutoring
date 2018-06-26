FactoryBot.define do
  factory :signup do
    subject  { Subject.last || FactoryBot.create(:subject) }
    student  { false }

    trait :as_student do
      student { true }
    end
  end
end
