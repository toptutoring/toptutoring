class PagesController < ApplicationController
  layout "authentication", only: [:payment]
  def admin_dashboard
    render "admin_dashboard", :layout => false
  end

  def director_dashboard
    render "director_dashboard", :layout => false
  end

  def tutor_dashboard
    render "tutor_dashboard", :layout => false
  end

  def calendar
    render "calendar", :layout => false
  end

  def payment
    @student_engagements = current_user.student_engagements
    @invoices = []

    @total_suggested_hours = 0
    @student_engagements.each do |engagement|
      invoices = Invoice.where(engagement_id: engagement.id)
      if invoices.count == 1
        if invoices.first.status != "paid"
          @invoices << invoices.first
          @total_suggested_hours += invoices.first.suggested_hours unless invoices.first.suggested_hours.nil?
        end
      end
    end


  end

  def first_session_payment

    @invoice = Invoice.find(params[:invoice])

    respond_to do |format|
      format.js { render :file => 'pages/first_session_payment.js.erb' }
    end
  end

  def low_balance_payment

    @invoice = Invoice.find(params[:invoice])
    @count = params[:count]

    respond_to do |format|
      format.js { render :file => 'pages/low_balance_payment.js.erb' }
    end
  end
end
