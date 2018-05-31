class Refund < ApplicationRecord
  belongs_to :payment

  validates_presence_of :payment, :stripe_refund_id, :reason

  monetize :amount_cents, numericality: { greater_than: 0 }

  delegate :rate_cents, to: :payment

  def set_amount
    self.amount_cents = calculate_amount_cents
  end

  def calculate_amount_cents
    if payment.refundable_hours == hours
      payment.amount_cents - payment.refunds.sum(:amount_cents)
    else
      (hours * rate_cents).floor
    end
  end
end
