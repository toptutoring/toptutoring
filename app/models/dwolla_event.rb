class DwollaEvent < ApplicationRecord
  has_one :payout, foreign_key: :dwolla_transfer_url, primary_key: :resource_url
  has_many :mass_pay_payouts, class_name: "Payout", foreign_key: :dwolla_mass_pay_url, primary_key: :resource_url

  def payout_status
    case topic
    when "transfer_completed"
      "paid"
    when "transfer_failed"
      "failed"
    when "transfer_cancelled"
      "cancelled"
    end
  end
end
