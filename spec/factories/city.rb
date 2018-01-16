FactoryBot.define do
  factory :city do
    country { FactoryBot.create(:country) }
    state "California"
    sequence(:name) { |n| "CityName#{n}" }
    phone_number "(510) 555-5555"
    description "This is a great city"
  end
end
