class CreditUpdater
  attr_reader :errors

  def initialize(invoice)
    @invoice = invoice
    @submitter = @invoice.submitter
    @engagement = @invoice.engagement
    @client = @engagement.client if @engagement
  end

  def process_creation_of_invoice!
    ActiveRecord::Base.transaction do
      subtract_from_client_credit(@invoice.hours) if @client
      add_to_submitter_balance(@invoice.hours)
      @invoice.save!
    end
  end

  def process_payment_of_invoice!
    ActiveRecord::Base.transaction do
      subtract_from_submitter_balance(@invoice.hours)
      @invoice.save!
    end
  end

  def update_existing_invoice(update_params)
    old_hours = @invoice.hours.to_f
    new_hours = update_params[:hours].to_f
    difference = new_hours - old_hours
    ActiveRecord::Base.transaction do
      absolute_amount = difference.abs
      if difference.positive?
        add_to_submitter_balance(absolute_amount)
        subtract_from_client_credit(absolute_amount) if @client
      elsif difference.negative?
        subtract_from_submitter_balance(absolute_amount)
        add_to_client_credit(absolute_amount) if @client
      else
        # Don't do anything if hours did not change
      end
      @invoice.update(update_params)
    end
  end

  def client_low_balance?
    return nil unless @engagement
    if @engagement.academic?
      @client.academic_credit <= 0.5
    elsif @engagement.test_prep?
      @client.test_prep_credit <= 0.5
    end
  end

  private

  def subtract_from_client_credit(hours)
    if @engagement.academic?
      @client.academic_credit -= hours
    elsif @engagement.test_prep?
      @client.test_prep_credit -= hours
    end
    @client.save!
  end

  def add_to_client_credit(hours)
    if @engagement.academic?
      @client.academic_credit += hours
    elsif @engagement.test_prep?
      @client.test_prep_credit += hours
    end
    @client.save!
  end

  def add_to_submitter_balance(hours)
    @submitter.outstanding_balance += hours
    @submitter.save!
  end

  def subtract_from_submitter_balance(hours)
    @submitter.outstanding_balance -= hours
    @submitter.save!
  end
end
