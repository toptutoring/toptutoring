module Tutors
  class SubjectsController < ApplicationController
    before_action :require_login

    def index
      @tutor_account = current_user.tutor_account
    end

    def update
      current_user.tutor_account.subject_ids = subject_params[:subject_ids]
      flash.notice = I18n.t("app.tutors.subjects.update_success")
      redirect_to action: :index
    end

    private

    def subject_params
      params.require(:tutor_account).permit(subject_ids: [])
    end
  end
end
