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
    Struct.new(:failed?, :low_balance?).new(false, client_low_balance?)
  rescue ActiveRecord::RecordInvalid => e
    Struct.new(:failed?).new(true)
  end

  def process_denial_of_invoice!
    ActiveRecord::Base.transaction do
      add_to_client_credit(@invoice.hours) if @client
      subtract_from_submitter_balance(@invoice.hours)
      @invoice.status = "denied"
      @invoice.save!
    end
  end

  def process_payment_of_invoice!
    ActiveRecord::Base.transaction do
      subtract_from_submitter_balance(@invoice.hours)
      @invoice.status = "processing"
      @invoice.save!
    end
  end

  def process_deletion_of_invoice!
    ActiveRecord::Base.transaction do
      add_to_client_credit(@invoice.hours) if @client
      subtract_from_submitter_balance(@invoice.hours)
      @invoice.destroy
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
      update_invoice(update_params)
    end
  end

  private

  def client_low_balance?
    return nil unless @engagement
    if @engagement.academic?
      @client.online_academic_credit <= 0.5
    elsif @engagement.test_prep?
      @client.online_test_prep_credit <= 0.5
    end
  end


  def subtract_from_client_credit(hours)
    if @engagement.academic?
      if @invoice.online?
        @client.online_academic_credit -= hours
      else
        @client.in_person_academic_credit -= hours
      end
    elsif @engagement.test_prep?
      if @invoice.online?
        @client.online_test_prep_credit -= hours
      else
        @client.in_person_test_prep_credit -= hours
      end
    end
    @client.save!
  end

  def add_to_client_credit(hours)
    if @engagement.academic?
      if @invoice.online?
        @client.online_academic_credit += hours
      else
        @client.in_person_academic_credit += hours
      end
    elsif @engagement.test_prep?
      if @invoice.online?
        @client.online_test_prep_credit += hours
      else
        @client.in_person_test_prep_credit += hours
      end
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

  def update_invoice(update_params)
    @invoice.update(update_params)
    @invoice.submitter_pay = submitter_pay
    @invoice.amount = updated_amount if @client
    @invoice.save!
  end

  def updated_amount
    if @engagement.academic?
      rate = @invoice.online? ? @client.online_academic_rate : @client.in_person_academic_rate
    elsif @engagement.test_prep?
      rate = @invoice.online? ? @client.online_test_prep_rate : @client.in_person_test_prep_rate
    else
    end
    @invoice.hours * rate
  end

  def submitter_pay
    if @invoice.by_tutor?
      account = @submitter.tutor_account
      rate = @invoice.online? ? account.online_rate : account.in_person_rate
    elsif @invoice.by_contractor?
      rate = @submitter.contractor_account.hourly_rate
    end
    @invoice.hours * rate
  end
end
