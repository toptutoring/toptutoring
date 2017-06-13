FactoryGirl.define do
  factory :credit_card do
    customer_id { "xxx" }
    primary     { true }
    confirmed   { true }
  end
end
