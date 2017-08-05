FactoryGirl.define do
  factory :payment do
    amount_in_cents      { 20000 }
    description { "Test payment" }
    payer       { FactoryGirl.create(:admin_user) }
    customer_id { "xxx" }
  end
end
