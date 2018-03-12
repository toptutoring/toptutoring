class StripeAccountService
  class << self
    Result = Struct.new(:success?, :message, :source)

    def create_account!(user, token_id)
      if user.stripe_account
        card = user.stripe_account.attach_card(token_id)
        Result.new(true, success(card), card.id)
      else
        stripe_customer = create_new_stripe_customer(user, token_id)
        account = user.create_stripe_account!(customer_id: stripe_customer.id)
        card_id = stripe_customer.default_source
        Result.new(true, success(account.get_card(card_id)), card_id)
      end
    rescue Stripe::StripeError => e
      Bugsnag.notify("Stripe Error: " + e.message)
      Result.new(false, "There was an error adding your card on file.")
    end

    def remove_card!(user, card_id)
      return Result.new(false, "No card to remove") unless user.stripe_account
      if user.stripe_account.remove_card(card_id)
        Result.new(true, "Card has been removed.")
      else
        Result.new(false, "Unable to remove card.")
      end
    rescue Stripe::StripeError => e
      Bugsnag.notify("Stripe Error: " + e.message)
      Result.new(false, "There was an error while removing your card.")
    end

    private

    def create_new_stripe_customer(user, token_id)
      Stripe::Customer.create(
        description: "Customer account for #{user.full_name} with id ##{user.id}.",
        source: token_id
      )
    end

    def success(card)
      "#{card.brand} ending in #{card.last4} has been added to your account."
    end
  end
end
