FactoryBot.define do
  factory :stripe_account do
    customer_id { Stripe::Customer.create(source: "tok_visa").id }
    user { FactoryBot.create(:client_user) }
  end
end
