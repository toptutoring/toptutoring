class TimesheetsController < ApplicationController
  def index
    @timesheets = current_user.invoices.by_contractor
  end

  def destroy
    current_user.invoices.by_contractor.pending.find(params[:id]).destroy
    redirect_to({ action: "index" }, notice: "Timesheet deleted")
  end
end
