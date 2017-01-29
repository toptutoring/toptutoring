module Admin
  class TutorsController < ApplicationController
  before_action :require_login

    def index
      @users = User.all.select { |user| user.tutor? }
    end
  end
end
