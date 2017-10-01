class CreditUpdater
  def initialize(invoice_id, new_hours = nil)
    @new_hours = new_hours
    @invoice = Invoice.find(invoice_id)
    @engagement = @invoice.engagement
    @client = @engagement.client
    @tutor = @invoice.tutor
  end

  def process!
    subtract_from_client_credit(@invoice.hours)
    add_to_tutor_balance(@invoice.hours)
  end

  def client_balance
    academic? ? @client.academic_credit : @client.test_prep_credit
  end

  def update_existing_invoice
    old_hours = @invoice.hours.to_f
    new_hours = @new_hours.to_f
    difference = new_hours - old_hours

    ActiveRecord::Base.transaction do
      if difference.positive?
        absolute_amount = difference.abs
        add_to_tutor_balance(absolute_amount)
        subtract_from_client_credit(absolute_amount)
      elsif difference.negative?
        absolute_amount = difference.abs
        subtract_from_tutor_balance(absolute_amount)
        add_to_client_credit(absolute_amount)
      else
        # Don't do anything if hours did not change
      end
      @invoice.update(@update_params)
    end
  end

  private

  def subtract_from_client_credit(hours)
    if @engagement.academic?
      @client.academic_credit -= hours
    elsif @engagement.test_prep?
      @client.test_prep_credit -= hours
    end
    @client.save
  end

  def add_to_client_credit(hours)
    if @engagement.academic?
      @client.academic_credit += hours
    elsif @engagement.test_prep?
      @client.test_prep_credit += hours
    end
    @client.save
  end

  def add_to_tutor_balance(hours)
    @tutor.outstanding_balance += hours
    @tutor.save
  end

  def subtract_from_tutor_balance(hours)
    @tutor.outstanding_balance -= hours
    @tutor.save
  end
end
