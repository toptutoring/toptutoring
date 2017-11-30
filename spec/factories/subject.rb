FactoryGirl.define do
  factory :subject do
    sequence(:name)  { |n| "Subject#{n}" }
    academic_type    { "academic" }
  end
end
