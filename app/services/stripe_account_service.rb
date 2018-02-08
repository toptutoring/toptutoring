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
        Result.new(true, success(account.default_card), stripe_customer.default_source)
      end
    rescue Stripe::StripeError => e
      Bugsnag.notify("Stripe Error: " + e.message)
      Result.new(false, "There was an error adding your card on file.")
    end

    private

    def create_new_stripe_customer(user, token_id)
      Stripe::Customer.create(
        description: "Customer account for #{user.name} with id ##{user.id}.",
        source: token_id
      )
    end

    def success(card)
      "#{card.brand} ending in #{card.last4} has been added to your account."
    end
  end
end
