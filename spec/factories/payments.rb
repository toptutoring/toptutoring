FactoryBot.define do
  factory :payment do
    amount_cents { 40_00 }
    description  { "Test payment" }
    payer        { FactoryBot.create(:admin_user) }
    customer_id  { "xxx" }
    rate_cents   { 20_00 }
    hours_purchased { 2 }
    hours_type { "academic" }
    card_holder_name { "Client" }
    stripe_charge_id { "ch_xxx" }
    last_four { "xxxx" }
    card_brand { "Visa" }
  end
end
