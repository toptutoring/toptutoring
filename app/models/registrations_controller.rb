class RegistrationsController < Devise::RegistrationsController
  def new
    super do
      resource.build_student
    end
  end

  private

  def sign_up_params
    params.require(:user).permit(:name, :email, :phone_number, :password, :password_confirmation, student_attributes: [:name, :email, :phone_number])
  end

  def account_update_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :current_password)
  end

  def after_sign_up_path_for(resource)
    if resource.has_card_info?
      new_payments_path
    else
      new_payment_informations_path
    end
  end
end
