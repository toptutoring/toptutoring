FactoryBot.define do
  factory :payout do
    description "Payment for 10hrs of tutoring."
    destination "recipient_dwolla_code"
    dwolla_transfer_url "dwolla_transfer_url"
    status "pending"
    funding_source ENV.fetch("DWOLLA_DEV_FUNDING_SOURCE")
    amount "100"
  end
end
