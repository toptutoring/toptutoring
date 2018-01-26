class Payment < ActiveRecord::Base
  # Associations #
  belongs_to :payer, class_name: "User", foreign_key: "payer_id"
  belongs_to :stripe_account

  # Validations #
  validates_presence_of :payer_id, :hours_type, :card_holder_name,
                        :last_four, :card_brand
  validates :amount_cents, :rate_cents, :hours_purchased, numericality: { greater_than_or_equal_to: 1 }

  # Monetize amounts
  monetize :amount_cents, :rate_cents

  # Scopes #
  scope :from_user, ->(payer_id) { where(payer_id: payer_id) }

  def card_brand_and_four_digits
    card_brand + " ending in ..." + last_four
  end
end
