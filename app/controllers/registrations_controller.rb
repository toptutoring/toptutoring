class RegistrationsController < Devise::RegistrationsController
  if Rails.env.production?
    force_ssl(host: "toptutoring.herokuapp.com/sign_up")
  end

  def create
    super do
      Stripe.api_key = ENV['STRIPE_SECRET_KEY']
      token = params[:stripeToken]

      begin
        customer = Stripe::Customer.create(
        source: token,
        email: sign_up_params[:email])

        resource.customer_id = customer.id
        resource.save
      rescue Stripe::CardError => e
        flash[:danger] = e.message
        redirect_to new_user_registration_path(resource)
        return
      end
     end
  end

  def show
    @user = User.find(params[:user_id])
    render :layout => false
  end

  private

  def sign_up_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def account_update_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :current_password)
  end

  def after_sign_up_path_for(resource)
    new_payments_path(host: ENV['HOST'], protocol: "http")
  end
end
