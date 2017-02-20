module Users
  class TutorsController < ApplicationController
    before_filter :redirect_to_root, :only => [:new, :create], :if => :signed_in?
    layout "authentication"

    def new
      @user = User.new
      @user.build_tutor
    end

    def create
      @user = Clearance.configuration.user_model.new(signups_params)
      if @user.save
        sign_in(@user)
        redirect_to :root
      else
        redirect_to :back, flash: { error: @user.errors.full_messages }
      end
    end

    private

    def signups_params
      params.require(:user).permit(:name, :email, :password, tutor_attributes: [:academic_type])
    end

  end
end
