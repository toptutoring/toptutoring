module Tutors
  class StudentsController < ApplicationController
    before_action :require_login

    def index
      @students = User.where(id: current_user.tutor_engagements.pluck(:student_id).uniq)
    end
  end
end
