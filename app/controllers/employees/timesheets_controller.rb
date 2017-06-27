module Employees
  class TimesheetsController < ApplicationController
    before_action :require_login

    def create
      if hours_valid? && date_valid?
        if current_user.timesheets.create(timesheet_params)
          redirect_to employees_timesheets_path, notice: 'Thank you for submitting your timesheet.' and return
        else
          redirect_back(fallback_location: (request.referer || root_path),
                        flash: { error: @invoice.errors.full_messages }) and return
        end
      else
          redirect_back(fallback_location: (request.referer || root_path),
                        flash: { error: "Please input valid hours in order to submit your timesheet." }) and return
      end
    end

    def index
      @timesheets = current_user.timesheets
    end

    def edit
      if not_paid?
        @timesheet = current_user.timesheets.find(params[:id])
      else
        redirect_to(employees_timesheets_path, notice: 'This invoice is already paid and can not be updated.') and return
      end
    end

    def update
      if hours_valid? && date_valid? && not_paid?
        @timesheet = current_user.timesheets.find(params[:id])
        if @timesheet.update(timesheet_params)
          redirect_to(employees_timesheets_path, notice: 'Your timesheet has been updated') and return
        else
          redirect_back(fallback_location: (request.referer || root_path),
                        flash: { error: @invoice.errors.full_messages }) and return
        end
      else
          redirect_back(fallback_location: (request.referer || root_path),
                        flash: { error: "Please input valid hours in order to update your timesheet." }) and return
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
    
    def hours_valid?
      hours_divided = params[:timesheet][:hours].to_f / 0.25
      hours_divided == hours_divided.to_i
    end

    def date_valid?
      params[:timesheet][:date].to_date <= Date.today
    end

    def not_paid?
      current_user.timesheets.find(params[:id]).status != "paid"
    end
  end
end
