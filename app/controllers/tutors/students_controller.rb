module Tutors
  class StudentsController < ApplicationController
    before_action :require_login

    def index
      @students = current_user.assignments.map(&:student).uniq
    end
  end
end
