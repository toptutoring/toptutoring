module Users
  class TutorsController < ApplicationController
    before_action :redirect_to_root, :only => [:new, :create], :if => :signed_in?
    layout "authentication"

    def new
      @user = User.new
    end

    def create
      results = CreateTutorService.create!(signups_params, tutor_subject_params)
      if results.success?
        sign_in(results.user)
        flash.notice = results.message
        redirect_to :root
      else
        @user = results.user
        flash.alert = results.message
        render :new
      end
    end

    def signup
    end

    private

    def signups_params
      params.require(:user)
            .permit(:name, :phone_number, :email, :password)
            .merge(roles: Role.where(name: "tutor"), access_state: "enabled")
    end

    def tutor_subject_params
      params.fetch(:tutor, {}).permit(subjects: [])
    end

    def redirect_to_root
      redirect_to root_path
    end
  end
end
