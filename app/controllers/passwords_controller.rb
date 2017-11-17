class PasswordsController < Clearance::PasswordsController
  layout "authentication"

  def edit
    sign_out if current_user
    @user = User.find(params[:user_id])
  end
end
