module Contractors
  class TimesheetsController < ApplicationController
    before_action :require_login
    before_action :check_if_update_possible, only: [:update, :destroy]

    def create
      @timesheet = current_user.timesheets.new(timesheet_params) 
      if @timesheet.save
        redirect_to contractors_timesheets_path, notice: 'Thank you for submitting your timesheet.' and return
      else
        redirect_back(fallback_location: (request.referer || root_path),
                      flash: { error: @timesheet.errors.full_messages }) and return
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
        redirect_to(contractors_timesheets_path, notice: 'Your timesheet has been updated') and return
      else
        redirect_back(fallback_location: (request.referer || root_path),
                      flash: { error: @timesheet.errors.full_messages }) and return
      end
    end

    def destroy
      if @timesheet.destroy
        redirect_to(contractors_timesheets_path, notice: 'Your timesheet has been deleted.') and return
      else
        redirect_back(fallback_location: (request.referer || root_path),
                      flash: { error: @timesheet.errors.full_messages }) and return
      end
    end

    private

    def timesheet_params
      minutes = (params[:timesheet][:hours].to_f * 60).to_i
      params.require(:timesheet).except(:hours)
            .permit(:minutes, :date, :description)
            .merge(status: "pending", minutes: minutes)
    end
    
    def not_paid?
      current_user.timesheets.find(params[:id]).status != "paid"
    end

    def check_if_update_possible
        @timesheet = current_user.timesheets.find(params[:id])
        if @timesheet.status == "paid"
          redirect_to(contractors_timesheets_path, notice: 'This timesheet is already paid and can not be updated.') and return
        end
    end
  end
end
