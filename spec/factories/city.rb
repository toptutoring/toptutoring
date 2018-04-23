FactoryBot.define do
  factory :city do
    country { FactoryBot.create(:country) }
    state "Ca"
    sequence(:name) { |n| "CityName#{n}" }
    phone_number "(510) 555-5555"
    description "This is a great city"
    address "1234 Glory Way"
    zip "94501"
  end
end
