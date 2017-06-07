module Tutors
  class StudentsController < ApplicationController
    before_action :require_login

    def index
      @student_tutor_engagements = current_user.tutor_engagements.uniq
    end
  end
end
