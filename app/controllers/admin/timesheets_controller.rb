module Admin
  class TimesheetsController < ApplicationController
    before_action :require_login

    def index
      @timesheets = Invoice.by_contractor.includes(:submitter)
    end
  end
end
