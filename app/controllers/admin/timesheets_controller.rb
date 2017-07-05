module Admin
  class TimesheetsController < ApplicationController
    before_action :require_login

    def index
      @timesheets = Timesheet.all
    end
  end
end
