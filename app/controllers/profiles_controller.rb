class ProfilesController < ApplicationController
  before_action :require_login

  def show
  end

  def edit
  end

  def update
    User.find(current_user.id).update(update_params)
    redirect_to profile_path, flash: { success: "Your profile has been updated." }
  end

  private

  def update_params
    params.require(:user).permit(:name, :phone_number)
  end
end
