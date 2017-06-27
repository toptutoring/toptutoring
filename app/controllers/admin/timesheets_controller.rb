module Admin
  class TimesheetsController < ApplicationController
    before_action :require_login

    def index
      @timesheets = Timesheet.all
    end

    def edit

    end

    def update

    end
    
    def destroy

    end
  end
end
