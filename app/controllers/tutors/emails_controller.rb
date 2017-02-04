module Tutors
  class EmailsController < ApplicationController
    before_action :require_login

    def index
      @emails = current_user.emails
    end
  end
end
