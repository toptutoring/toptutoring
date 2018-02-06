FactoryBot.define do
  factory :payment do
    amount_cents { 40_00 }
    description  { "Test payment" }
    payer        { FactoryBot.create(:client_user) }
    rate_cents   { 20_00 }
    hours_purchased { 2 }
    hours_type { "academic" }
    card_holder_name { "Client" }
    stripe_source { "tok_4242424242" }
    stripe_charge_id { "ch_xxx" }
    last_four { "xxxx" }
    card_brand { "Visa" }

    after(:create) do |payment, _|
      payment.stripe_account = payment.payer.stripe_account
    end
  end
end
