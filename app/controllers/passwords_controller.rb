class PasswordsController < Clearance::PasswordsController
  layout "authentication"

  # TODO remove and change routes to default clearance once layouts become generic
  def create
    if User.find_by(email: email)
      super
    else
      flash.alert = "There is no user with the email you provided."
      render :new
    end
  end

  def edit
    # Sign out any current user that might already be logged in
    # to avoid signing in multiple users after password reset
    sign_out if current_user
    @user = User.find(params[:user_id])
  end

  private

  def email
    @email ||= params.require(:password).permit(:email)[:email]
  end
end
