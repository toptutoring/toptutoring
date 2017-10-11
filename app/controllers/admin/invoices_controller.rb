module Admin
  class InvoicesController < ApplicationController
    before_action :require_login

    def index
      @invoices = Invoice.by_tutor.includes(:engagement, :submitter, engagement: :client).newest_first
      @total_for_all = Invoice.tutor_pending_total
    end

    def edit
      @invoice = Invoice.find(params[:id])
    end

    def update
      @invoice = Invoice.find(params[:id])
      if CreditUpdater.new(@invoice).update_existing_invoice(update_params)
        redirect_to(admin_invoices_path, notice: 'The invoice has been updated') and return
      else
        redirect_back(fallback_location: (request.referer || root_path),
                      flash: { error: @invoice.errors.full_messages }) and return
      end
    end

    def update_params
      params.require(:invoice).permit(:status, :description, :hours)
    end
  end
end
