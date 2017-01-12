class UsersController < Clearance::SessionsController
  before_action :require_login

  def update
    if current_user.update_attributes(user_params)

      Stripe.api_key = ENV['STRIPE_SECRET_KEY']
      token = params[:stripeToken]

      begin
        customer = Stripe::Customer.create(
        source: token,
        email: current_user.email)

        current_user.customer_id = customer.id
        current_user.save!
        current_user.enable!
        redirect_to payment_new_path
        return
      rescue Stripe::CardError => e
        flash[:danger] = e.message
      else
        flash[:danger] = current_user.errors.full_messages
      end
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :phone_number, :password, student_attributes: [:id, :name, :email, :phone_number, :subject])
  end
end
