module Tutors
  class InvoicesController < ApplicationController
    before_action :require_login

    def index
      @invoices = current_user.invoices
    end
  end
end
