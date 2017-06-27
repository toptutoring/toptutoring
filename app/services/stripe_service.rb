class StripeService
  def initialize(user_id)
    @user_id = user_id
  end

  def retrieve_customer
    Stripe::Customer.retrieve customer_id
  end

  private

  def customer_id
    user.primary_credit_card.customer_id
  end

  def user
    @user ||= User.find(@user_id)
  end
end
