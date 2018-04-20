FactoryBot.define do
  factory :blog_category do
    sequence(:name) { |n| "category_#{n}"}
  end
end
