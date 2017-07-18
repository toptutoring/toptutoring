module Tutors
  class StudentsController < ApplicationController
    before_action :require_login

    def index
      @tutor_engagements = current_user.tutor_engagements.order(:student_name)
    end
  end
end
