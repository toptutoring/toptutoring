module Users
  class TutorsController < ApplicationController
    before_action :redirect_to_root, :only => [:new, :create], :if => :signed_in?
    layout "authentication"

    def new
      @user = User.new
      @user.build_tutor_account
    end

    def create
      results = CreateTutorService.create!(agreement_accepted,
                                           signups_params,
                                           password)
      if results.success?
        successful_redirect(results)
      else
        rerender_form(results)
      end
    end

    private

    def agreement_accepted
      params[:agreement].present?
    end

    def signups_params
      params.require(:user)
            .permit(:first_name, :last_name, :phone_number, :email, :password,
                   tutor_account_attributes: { subject_ids: [] })
            .merge(roles: Role.where(name: "tutor"), access_state: "enabled")
    end

    def password
      params.require(:confirm_password)
    end

    def redirect_to_root
      redirect_to root_path
    end

    def successful_redirect(results)
      sign_in(results.user)
      flash.notice = results.message
      redirect_to :root
    end

    def rerender_form(results)
      @user = results.user
      flash.now[:alert] = results.message
      render :new
    end
  end
end
