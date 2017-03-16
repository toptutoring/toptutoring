class UsersController < Clearance::SessionsController
  before_action :require_login

  def edit
    if !current_user.is_student?
      current_user.students.build
    end
  end

  def update
    if current_user.update_attributes(user_params)
      current_user.students.last.create_student_info(subject: current_user.client_info.subject)

      Stripe.api_key = ENV['STRIPE_SECRET_KEY']
      token = params[:stripeToken]

      begin
        customer = Stripe::Customer.create(
        source: token,
        email: current_user.email)

        current_user.customer_id = customer.id
        current_user.save!
        enable_user
      rescue Stripe::CardError => e
        redirect_back(fallback_location: (request.referer || root_path),
                      flash: { error: e.message })
        return
      else
        redirect_back(fallback_location: (request.referer || root_path),
                      flash: { error: current_user.errors.full_messages })
        return
      end
      redirect_to payment_new_path
      return
    end
  end

  private

  def enable_user
    if current_user.is_student?
      EnableUserAsStudent.new(current_user).perform
    else
      EnableUserWithStudent.new(current_user).perform
    end
  end

  def user_params
    if current_user.is_student?
      client_as_student_params
    else
      client_with_student_params
    end
  end

  def client_with_student_params
    params[:user][:students_attributes]["0"][:password] = rand(36**4).to_s(36)
    params.require(:user).permit(:name, :email, :phone_number, :password, students_attributes: [:id, :name, :email, :phone_number, :password, :subject])
  end

  def client_as_student_params
    params.require(:user).permit(:name, :email, :phone_number, :password, client_info_attributes: [:id, :subject])
  end
end
