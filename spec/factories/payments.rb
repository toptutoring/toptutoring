FactoryGirl.define do
  factory :payment do
    amount      { 200 }
    description { "Test payment" }
    payer       { FactoryGirl.create(:admin_user) }
    customer_id { "xxx" }
  end
end
