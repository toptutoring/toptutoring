FactoryBot.define do
  factory :payout do
    approver { User.admin }
    description "Payment for 10hrs of tutoring."
    destination "recipient_dwolla_code"
    dwolla_transfer_url "dwolla_transfer_url"
    receiving_account { FactoryBot.create(:tutor_account) }
    status "pending"
    funding_source ENV.fetch("DWOLLA_DEV_FUNDING_SOURCE")
    amount "100"
  end
end
