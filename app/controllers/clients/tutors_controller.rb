module Clients
  class TutorsController < ApplicationController
    before_action :require_login

    def index
      @tutors = current_user.student_account.tutors
      @pending_requests = current_user.student_account.engagements.pending
    end

    def show
      @tutor = User.find params[:id]
    end

    private

    def subject
      Subject.find(params[:engagement][:subject_id])
    end
  end
end
