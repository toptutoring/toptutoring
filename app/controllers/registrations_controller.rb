class RegistrationsController < Devise::RegistrationsController
  before_filter :authenticate_user!, except: [:new]
  before_filter :authorize_user, only: [:show]

  def new
    super do
      build_resource
      resource.build_student
    end
  end

  def show
    @user = User.find(params[:id])
  end

  private

  def sign_up_params
    params.require(:user).permit(:name, :email, :phone_number, :password, :password_confirmation, student_attributes: [:name, :email, :phone_number])
  end

  def account_update_params
    params.require(:user).permit(:name, :email, :phone_number, :password, :password_confirmation, :current_password, student_attributes: [:name, :email, :phone_number])
  end

  def after_sign_up_path_for(resource)
    if resource.has_card_info?
      new_payments_path
    else
      new_payment_informations_path
    end
  end

  def authorize_user
    if current_user.id != params[:id].to_i
      flash[:error] = 'Access denied'
      redirect_to root_url
    end
  end
end
