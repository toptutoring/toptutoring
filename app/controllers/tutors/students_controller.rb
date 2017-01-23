module Tutors
  class StudentsController < ApplicationController
    before_action :require_login
    before_action :set_user, only: [:edit, :update]

    def index
      @students = current_user.assignments.map(&:student).uniq
    end

  end
end
