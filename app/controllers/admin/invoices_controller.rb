module Admin
  class InvoicesController < ApplicationController
    before_action :require_login

    def index
      @invoices = Invoice.all.newest_first
    end
  end
end
