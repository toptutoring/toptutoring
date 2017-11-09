class TimesheetsController < ApplicationController
  def index
    @timesheets = current_user.invoices.by_contractor
  end

  def destroy
    timesheet = current_user.invoices.by_contractor.pending.find(params[:id])
    CreditUpdater.new(timesheet).process_deletion_of_invoice!
    redirect_to({ action: "index" }, notice: "Timesheet deleted")
  end
end
