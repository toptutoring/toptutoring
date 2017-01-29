FactoryGirl.define do
  factory :payment do
    amount      { 200 }
    description { "Test payment" }
    payer       { FactoryGirl.create(:admin_user) }
  end
end
