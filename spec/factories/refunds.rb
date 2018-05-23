FactoryBot.define do
  factory :refund do
    stripe_refund_id "r_1239102390"
    hours 1
    reason "Client requested refund."
    amount_cents 20_00
    payment 
  end
end
