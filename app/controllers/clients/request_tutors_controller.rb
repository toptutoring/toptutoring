module Clients
  class RequestTutorsController < ApplicationController
    before_action :require_login

    def new
      @student_account_id = params[:student_account_id]
      @engagement = Engagement.new
    end

    def create
      @engagement = Engagement.new(engagement_params)
      if @engagement.save
        flash.notice = "Thank you for making a request. We will contact you when we find a tutor."
        SlackNotifier.notify_new_engagement(@engagement)
        redirect_to return_path
      else
        flash.alert = "There was an error while processing your request."
        render :new
      end
    end

    def destroy
      current_user.client_account.engagements.pending.find(params[:id]).destroy
      flash.notice = "Your request has been removed."
      redirect_to return_path
    end

    private

    def engagement_params
      params.require(:engagement)
            .permit(:subject_id, :student_account_id)
            .merge(client_account: current_user.client_account)
    end

    def return_path
      current_user.is_student? ? clients_tutors_path : clients_students_path
    end
  end
end
