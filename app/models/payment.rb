class Payment < ActiveRecord::Base
  # Associations #
  belongs_to :payer, class_name: "User", foreign_key: "payer_id"
  belongs_to :stripe_account
  has_many :refunds

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
  scope :succeeded, -> { where(status: "succeeded") }
  scope :refunded, -> { where(status: "refunded") }

  def set_rate
    return if one_time
    self.rate_cents = case hours_type
                      when "online_academic"
                        payer.online_academic_rate_cents
                      when "online_test_prep"
                        payer.online_test_prep_rate_cents
                      when "in_person_academic"
                        payer.in_person_academic_rate_cents
                      when "in_person_test_prep"
                        payer.in_person_test_prep_rate_cents
                      end
  end

  def set_amount
    return if one_time
    self.amount_cents = (hours_purchased * rate_cents).floor
  end

  def set_default_description
    return if one_time
    hours = hours_purchased
    type = hours_type.humanize
    self.description = "Purchase of #{hours} #{type} hours."
  end


  def card_brand_and_four_digits
    card_brand + " ending in ..." + last_four
  end

  def payer_name
    payer ? payer.full_name : card_holder_name
  end

  def fully_refunded?
    return false unless hours_purchased
    hours_purchased == refunds.sum(:hours)
  end

  def refundable_hours
    return nil if one_time || !hours_purchased
    hours_purchased - refunds.sum(:hours)
  end
end
