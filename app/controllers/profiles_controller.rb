class ProfilesController < ApplicationController
  before_action :require_login

  def show
  end

  def edit
  end

  def update
    user = User.find(current_user.id)
    if user.update(update_params)
      flash.notice = "Your profile has been updated."
    else
      flash.alert = user.errors.full_messages
    end
    redirect_back fallback_location: profile_path
  end

  private

  def update_params
    params.require(:user).permit(:name, :phone_number)
  end
end
