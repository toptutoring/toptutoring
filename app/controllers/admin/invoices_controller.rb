module Admin
  class InvoicesController < ApplicationController
    before_action :require_login
    before_action :set_invoice, only: [:edit, :update, :deny]
    def index
      @invoices = Invoice.by_tutor.includes(:engagement, :submitter, engagement: :client_account).newest_first
      @total_for_all = Invoice.tutor_pending_total
    end

    def edit
    end

    def update
      if CreditUpdater.new(@invoice).update_existing_invoice(update_params)
        redirect_to return_path, notice: "The #{type} has been updated."
      else
        redirect_back(fallback_location: (request.referer || root_path),
                      flash: { error: @invoice.errors.full_messages }) and return
      end
    end

    def deny
      if CreditUpdater.new(@invoice).process_denial_of_invoice!
        redirect_to return_path, notice: "The #{type} has been denied."
      else
        redirect_back(fallback_location: (request.referer || root_path),
                      flash: { error: @invoice.errors.full_messages }) and return
      end
    end

    private

    def update_params
      params.require(:invoice).permit(:status, :description, :hours)
    end

    def set_invoice
      @invoice = Invoice.find(params[:id])
    end

   def type 
      @invoice.by_tutor? ? "invoice" : "timesheet"
   end

    def return_path
      @invoice.by_tutor? ? admin_invoices_path : admin_timesheets_path
    end
  end
end
