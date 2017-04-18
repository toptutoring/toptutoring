module Tutors
  class StudentsController < ApplicationController
    before_action :require_login

    def index
      @students = current_user.engagements.map(&:student).uniq.compact
    end
  end
end
