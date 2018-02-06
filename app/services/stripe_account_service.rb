class StripeAccountService
  class << self
    Result = Struct.new(:source, :message)

    def create_account!(user, token_id)
      if user.stripe_account
        Result.new(nil)
      else
        stripe_customer = create_new_stripe_customer(user, token_id)
        user.create_stripe_account!(customer_id: stripe_customer.id)
        Result.new(stripe_customer.default_source)
      end
    rescue Stripe::StripeError => e
      Bugsnag.notify("Stripe payment error for #{user.name + user.id.to_s}: " + e.message)
      Result.new(nil)
    end

    private

    def create_new_stripe_customer(user, token_id)
      Stripe::Customer.create(
        description: "Customer account for #{user.name} with id ##{user.id}.",
        source: token_id
      )
    end
  end
end
