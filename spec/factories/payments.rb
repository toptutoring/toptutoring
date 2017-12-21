FactoryBot.define do
  factory :payment do
    amount_cents { 200_00 }
    description  { "Test payment" }
    payer        { FactoryBot.create(:admin_user) }
    customer_id  { "xxx" }
  end
end
