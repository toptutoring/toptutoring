module Admin
  class EmailsController < ApplicationController
    before_action :require_login

    def index
      @emails = Email.all
    end
  end
end
