module Admin
  class TimesheetsController < ApplicationController
    before_action :require_login

    def index
      @timesheets = Timesheet.all
      @total_for_all = Timesheet.pending.map { |ts| ts.amount }.reduce(&:+)
    end

    def update
      @timesheet = Timesheet.find(params[:id])
      if @timesheet.update(update_params)
        redirect_to(admin_timesheets_path, notice: 'The timesheet has been updated') and return
      else
        redirect_back(fallback_location: (request.referer || root_path),
                      flash: { error: @timesheet.errors.full_messages }) and return
      end
    end

    private

    def update_params
      params.require(:timesheet).permit(:status)
    end
    
  end
end
