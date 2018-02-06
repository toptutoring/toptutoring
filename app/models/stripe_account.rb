class StripeAccount < ApplicationRecord
  belongs_to :user
  has_many :payments

  validates_presence_of :user, :customer_id

  def default_source_id
    customer.default_source
  end

  def default_card
    # returns Stripe::Card object
    customer.sources.retrieve(default_source_id)
  end

  def default_card_display
    card = default_card
    "#{card.brand} ending in #{card.last4}"
  end

  def customer
    # returns Stripe::Customer object
    Stripe::Customer.retrieve(customer_id)
  end
end
