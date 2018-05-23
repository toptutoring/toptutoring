class Refund < ApplicationRecord
  belongs_to :payment

  validates_presence_of :payment, :stripe_refund_id, :reason

  monetize :amount_cents, numericality: { greater_than: 0 }
end
