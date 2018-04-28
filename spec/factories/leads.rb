FactoryBot.define do
  factory :lead do
    sequence(:email) { |n| "client_#{n}@example.com" }
    sequence(:first_name) { |n| "Client#{n}" }
    sequence(:last_name) { |n| "ClientLastName#{n}" }
    phone_number "MyString"
    zip "94501"
    comments "MyText"
  end
end
