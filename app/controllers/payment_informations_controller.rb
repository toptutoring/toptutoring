class PaymentInformationsController  < ApplicationController
  before_action :authenticate_user!
  if Rails.env.production?
    force_ssl(host: "toptutoring.herokuapp.com/payment_information/new")
  end

  def new
  end

  def create
      Stripe.api_key = ENV['STRIPE_SECRET_KEY']
      token = params[:stripeToken]

      begin
        customer = Stripe::Customer.create(
        source: token,
        email: current_user.email)

        current_user.customer_id = customer.id
        current_user.save
        redirect_to user_path(current_user)
      rescue Stripe::CardError => e
        flash[:danger] = e.message
        redirect_to new_payment_informations_path
        return
      end
  end
end
