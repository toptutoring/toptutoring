module Admin
  class TutorsController < ApplicationController
    before_action :require_login
    before_action :set_tutor, only: [:edit, :update]

    def index
      @tutors = User.tutors
      @subject_id = params[:subject_id]
      select_tutors unless @subject_id.nil? || @subject_id.empty?
    end

    def show
      @tutor = User.find(params[:id])
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

    def select_tutors
      @tutors = @tutors.joins(tutor_account: :subjects)
                       .where(subjects: { id: @subject_id })
    end

    def tutor_params
      params.require(:user).permit(:first_name, :last_name, :email, tutor_account_attributes: [:id, :online_rate, :in_person_rate])
    end

    def set_tutor
      @tutor = User.find(params[:id])
    end
  end
end
