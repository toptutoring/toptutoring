module Admin
  class InvoicesController < ApplicationController
    before_action :require_login

    def index
      @invoices = Invoice.all.newest_first
      @total_for_all = Invoice.pending.map(&:tutor_pay).reduce(:+)
    end

    def edit
      @invoice = Invoice.find(params[:id])
    end

    def update
      @invoice = Invoice.find(params[:id])

      if CreditUpdater.new(@invoice.id, update_params[:hours]).update_existing_invoice
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
