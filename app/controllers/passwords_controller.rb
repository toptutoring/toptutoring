class PasswordsController < Clearance::PasswordsController
  layout "authentication"

  def edit
    # Sign out any current user that might already be logged in
    # to avoid signing in multiple users after password reset
    sign_out if current_user
    @user = User.find(params[:user_id])
  end
end
