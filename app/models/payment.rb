class Payment < ActiveRecord::Base
  # Associations #
  belongs_to :payer, class_name: "User", foreign_key: "payer_id"
  belongs_to :stripe_account

  # Validations for purchases
  validates_presence_of :payer_id, :hours_type, unless: :one_time
  validates :amount, :rate, numericality: { greater_than_or_equal_to: 1 }, unless: :one_time
  validates :hours_purchased, numericality: { greater_than_or_equal_to: 0.5 }, unless: :one_time

  # Validations for one time payment
  validates_presence_of :payer_email, if: :one_time
  validates :amount, numericality: { greater_than_or_equal_to: 1 }, if: :one_time

  # Monetize amounts
  monetize :amount_cents, :rate_cents, allow_nil: true

  # Scopes #
  scope :from_user, ->(payer_id) { where(payer_id: payer_id) }

  def card_brand_and_four_digits
    card_brand + " ending in ..." + last_four
  end
end
