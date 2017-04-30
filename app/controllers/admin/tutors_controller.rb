module Admin
  class TutorsController < ApplicationController
    before_action :require_login
    before_action :set_tutor, only: [:edit, :update]

    def index
      @tutors = User.with_tutor_role
    end

    def update
      if @tutor.update_attributes(tutor_params)
        redirect_to admin_tutors_path, notice: 'Tutor successfully updated!'
      else
        redirect_back(fallback_location: (request.referer || root_path),
                      flash: { error: @tutor.errors.full_messages })
      end
    end

    private

    def tutor_params
      params.require(:user).permit(:name, :email)
    end

    def set_tutor
      @tutor = User.find(params[:id])
    end
  end
end
