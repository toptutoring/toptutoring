module Tutors
  class InvoicesController < ApplicationController
    before_action :require_login
    before_action :authorize_tutor, only: :create

    def index
      @invoices = current_user.invoices.by_tutor.includes(:engagement, :client)
    end

    def create
      update_no_show_params if params[:invoice][:hours] == "no_show"
      create_invoice
      adjust_balances_and_save_records
      redirect_to dashboard_path
    end

    def destroy
      invoice = current_user.invoices.by_tutor.pending.find(params[:id])
      CreditUpdater.new(invoice).process_deletion_of_invoice!
      redirect_to({ action: "index" }, notice: "Invoice has been deleted")
    end

    private

    def update_no_show_params
      params[:invoice][:hours] = 0
      @note = "No Show"
    end

    def create_invoice
      @by_tutor = params[:invoice][:submitter_type] == "by_tutor"
      set_engagement_and_client if @by_tutor
      @invoice = Invoice.new(invoice_params)
    end

    def invoice_params
      params.require(:invoice)
            .permit(:engagement_id, :subject, :hours, :session_rating,
                    :description, :submitter_type, :online)
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
        online? ? @client.online_academic_rate :  @client.in_person_academic_rate
      elsif @engagement.test_prep?
        online? ? @client.online_test_prep_rate : @client.in_person_test_prep_rate
      end
    end

    def client_charge
      return nil unless @client
      hourly_rate * params[:invoice][:hours].to_f
    end

    def submitter_pay
      if @by_tutor
        account = current_user.tutor_account
        submitter_rate = online? ? account.online_rate : account.in_person_rate
      else
        submitter_rate = current_user.contractor_account.hourly_rate
      end
      submitter_rate * params[:invoice][:hours].to_f
    end

    def online?
      @online ||= params[:invoice][:online] == "true"
    end

    def set_engagement_and_client
      engagement_id = params[:invoice][:engagement_id]
      @engagement = current_user.tutor_account.engagements.find(engagement_id)
      @client = @engagement.client
    end

    def adjust_balances_and_save_records
      adjuster = CreditUpdater.new(@invoice).process_creation_of_invoice!
      if adjuster.failed?
        flash.alert = "There was an error while creating your invoice."
      elsif adjuster.low_balance?
        flash.alert = "Your invoice has been created. However, your client is running low on their balance. Please consider making a suggestion to your client to add to their balance before scheduling any more sessions."
      else
        flash.notice = @by_tutor ? "Invoice has been created." : "Timesheet has been created."
      end
    end

    def authorize_tutor
      return if params[:invoice][:submitter_type] == "by_contractor"
      return if current_user.tutor_account.engagements.active.find_by_id(params[:invoice][:engagement_id])
      flash.alert = "There was an error while processing your invoice. Please check with your tutor director if you have been set up yet to tutor this client." 
      redirect_to dashboard_path
    end

    def send_emails
      return unless @by_tutor
      UserNotifierMailer.send_invoice_notice(@client, @invoice).deliver_later
    end
  end
end
