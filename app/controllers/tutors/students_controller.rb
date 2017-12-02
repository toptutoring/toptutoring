module Tutors
  class StudentsController < ApplicationController
    before_action :require_login

    def index
      @tutor_engagements = current_user.tutor_engagements
                                       .includes(:subject, :student_account)
                                       .order("student_accounts.name")
    end
  end
end
