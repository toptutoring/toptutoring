module Clients
  class RequestTutorsController < ApplicationController
    before_action :require_login, :handle_no_students

    def new
      @student_account_id = params[:student_account_id]
      @engagement = Engagement.new
    end

    def create
      @engagement = Engagement.new(engagement_params)
      if @engagement.save
        flash.notice = I18n.t("app.request_tutor.success")
        SlackNotifier.notify_new_engagement(@engagement)
        redirect_to return_path
      else
        flash.alert = I18n.t("app.request_tutor.failure")
        render :new
      end
    end

    def destroy
      current_user.client_account.engagements.pending.find(params[:id]).destroy
      flash.notice = I18n.t("app.request_tutor.destroy")
      redirect_to return_path
    end

    private

    def engagement_params
      params.require(:engagement)
            .permit(:subject_id, :student_account_id)
            .merge(client_account: current_user.client_account)
    end

    def return_path
      current_user.student_account ? clients_tutors_path : clients_students_path
    end

    def handle_no_students
      return if current_user.student_account
      return if current_user.client_account.student_accounts.any?
      flash.notice = "Please add a student before requesting tutors."
      redirect_to new_clients_student_path
    end
  end
end
