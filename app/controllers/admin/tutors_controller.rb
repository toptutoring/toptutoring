module Admin
  class TutorsController < ApplicationController
  before_action :require_login

    def index
      @users = User.with_tutor_role
    end
  end
end
