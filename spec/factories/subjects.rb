FactoryBot.define do
  factory :subject do
    sequence(:name)  { |n| "Subject#{n}" }
    academic_type    { "academic" }
    category         { "other" }
  end
end
