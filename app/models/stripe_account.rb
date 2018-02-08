class StripeAccount < ApplicationRecord
  belongs_to :user
  has_many :payments

  validates_presence_of :user, :customer_id

  def default_source_id
    customer.default_source
  end

  def default_card
    # returns Stripe::Card object
    get_card(default_source_id)
  end

  def default_source_display
    card_display(default_card)
  end

  def customer
    # returns Stripe::Customer object
    Stripe::Customer.retrieve(customer_id)
  end

  def get_card(card_id)
    sources.retrieve(card_id)
  end

  def attach_card(token)
    card = sources.create(source: token)
    customer.save
    card
  end

  def sources
    customer.sources.all
  end
  private

  def card_display(card)
    "#{card.brand} ending in #{card.last4}"
  end
end
