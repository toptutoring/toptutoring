FactoryBot.define do
  factory :payment do
    amount_cents { 40_00 }
    card_holder_name { "Client" }
    stripe_source { "tok_4242424242" }
    stripe_charge_id { "ch_xxx" }
    last_four { "xxxx" }
    card_brand { "Visa" }
    status { "succeeded" }

    trait :hourly_purchase do
      description  { "Purchase of 2 hours" }
      payer        { FactoryBot.create(:client_user) }
      rate_cents   { 20_00 }
      hours_purchased { 2 }
      hours_type { "academic" }

      after(:create) do |payment, _|
        payment.stripe_account = payment.payer.stripe_account unless payment.payer
      end
    end

    trait :one_time_payment do
      payer_email { "client@example.com" }
      description  { "One Time Payment for Clinet" }
      one_time { true }
    end
  end
end
