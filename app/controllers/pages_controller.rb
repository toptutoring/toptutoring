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

    @student_engagements = get_student_engagements
    @invoices = []

    @total_suggested_hours = 0
    @student_engagements.each do |engagement|
      invoices = Invoice.where(engagement_id: engagement.id)
      if invoices.count == 1
        if invoices.first.status != "paid"
          @invoices << invoices.first
          @total_suggested_hours += engagement.suggestions.last.suggested_minutes/60.0
        end
      end
    end


  end

  def first_session_payment
    @engagement = Engagement.find(params[:engagement])
    respond_to do |format|
      format.js { render :file => 'pages/first_session_payment.js.erb' }
    end
  end

  def low_balance_payment

    @engagement = Engagement.find(params[:engagement])
    @count = params[:count]

    respond_to do |format|
      format.js { render :file => 'pages/low_balance_payment.js.erb' }
    end
  end

  private

  def get_student_engagements
    if !current_user.student_engagements.empty?
      current_user.student_engagements
    else
      current_user.client_engagements
    end
  end
end
