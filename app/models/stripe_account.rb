class StripeAccount < ApplicationRecord
  belongs_to :user
  has_many :payments

  validates_presence_of :user, :customer_id

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

  def remove_card(card_id)
    return false if sources.count <= 1
    card = get_card(card_id).delete
    card.deleted?
  end

  def sources
    customer.sources.all
  end

  def card_options
    sources.map do |card|
      [card_display(card), card.id]
    end
  end

  def default_display
    card_display(sources.first)
  end

  def card_display(card)
    "#{card.brand} ending in #{card.last4}"
  end
end
