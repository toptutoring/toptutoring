module Tutors
  class InvoicesController < ApplicationController
    before_action :require_login

    def index
      @invoices = current_user.invoices.by_tutor.includes(:engagement, :client)
    end

    def create
      update_no_show_params if params[:invoice][:hours] == 'no_show'
      create_invoice
      adjust_balances_and_save_records
      set_flash_messages
      if @by_tutor
        redirect_to tutors_invoices_path
      else
        redirect_to timesheets_path
      end
    end

    def destroy
      invoice = current_user.invoices.by_tutor.pending.find(params[:id])
      CreditUpdater.new(invoice).process_deletion_of_invoice!
      redirect_to({ action: "index" }, notice: "Invoice has been deleted")
    end

    private

    def update_no_show_params
      params[:invoice][:hours] = 0
      @note = 'No Show'
    end

    def create_invoice
      @by_tutor = params[:invoice][:submitter_type] == 'by_tutor'
      if @by_tutor
        authorize_tutor
        set_engagement_and_client
      end
      @invoice = Invoice.new(invoice_params)
    end

    def invoice_params
      params.require(:invoice)
            .permit(:engagement_id, :subject, :hours,
                    :description, :submitter_type)
            .merge(submitter: current_user, status: "pending",
                   submitter_pay: submitter_pay, client: @client,
                   amount: client_charge, hourly_rate: hourly_rate,
                   engagement: @engagement, subject: subject, note: @note)
    end

    def subject
      @client ? params[:invoice][:subject] : nil
    end

    def hourly_rate
      return nil unless @client
      if @engagement.academic?
        @client.academic_rate
      elsif @engagement.test_prep?
        @client.test_prep_rate
      end
    end

    def client_charge
      return nil unless @client
      hourly_rate * params[:invoice][:hours].to_f
    end

    def submitter_pay
      submitter_rate = current_user.contract.hourly_rate
      submitter_rate * params[:invoice][:hours].to_f
    end

    def set_engagement_and_client
      engagement_id = params[:invoice][:engagement_id]
      @engagement = current_user.engagements.find(engagement_id)
      @client = @engagement.client
    end

    def authorize_tutor
      unless current_user.engagements.where(state: "active").exists?(params[:invoice][:engagement_id].to_i)
        redirect_back(fallback_location: (request.referer || root_path),
                      flash: { error: "There was an error while processing your invoice. Please check with your tutor director if you have been set up yet to tutor this client." }) and return
      end
    end

    def adjust_balances_and_save_records
      @adjuster = CreditUpdater.new(@invoice)
      @adjuster.process_creation_of_invoice!
    end

    def set_flash_messages
      if @adjuster.errors
        flash.alert = "There was an error while creating your invoice."
      elsif @adjuster.client_low_balance?
        flash.alert = "Your invoice has been created. However, your client is running low on their balance. Please consider making a suggestion to your client to add to their balance before scheduling any more sessions."
      else
        flash.notice = @by_tutor ? "Invoice has been created." : "Timesheet has been created."
      end
    end
  end
end
