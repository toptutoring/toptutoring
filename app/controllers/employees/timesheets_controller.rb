module Employees
  class TimesheetsController < ApplicationController
    before_action :require_login

    def create
      if current_user.timesheets.create(timesheet_params)
        redirect_to employees_timesheets_path, notice: 'Thank you for submitting your timesheet.' and return
      else
        redirect_back(fallback_location: (request.referer || root_path),
                      flash: { error: @invoice.errors.full_messages }) and return
      end
    end

    def index
      @timesheets = current_user.timesheets
    end

    def edit
      @timesheet = current_user.timesheets.find(params[:id])
    end

    def update
      @timesheet = current_user.timesheets.find(params[:id])
      if @timesheet.update(timesheet_params)
        redirect_to(employees_timesheets_path, notice: 'Your timesheet has been updated') and return
      else
        redirect_back(fallback_location: (request.referer || root_path),
                      flash: { error: @invoice.errors.full_messages }) and return
      end
    end
    
    def destroy
      @timesheet = current_user.timesheets.find(params[:id])
      if @timesheet.destroy
        redirect_to(employees_timesheets_path, notice: 'Your timesheet has been deleted.') and return
      else
        redirect_back(fallback_location: (request.referer || root_path),
                      flash: { error: @invoice.errors.full_messages }) and return
      end
    end

    private

    def timesheet_params
      params[:timesheet][:hours] = (params[:timesheet][:hours].to_f * 60).to_i
      params.require(:timesheet)
        .permit(:hours, :date, :description)
        .merge(status: "pending")
    end
  end
end
