class BalanceAdjuster
  attr_reader :errors
  def initialize(invoice, submitter, client = nil)
    @invoice = invoice
    @submitter = submitter
    @client = client
  end

  def add_to_submitter_balance
    @submitter.outstanding_balance += @invoice.hours
    @submitter.save
  end

  def lower_submitter_balance
    @submitter.outstanding_balance -= @invoice.hours
  end

  def subtract_from_client_balance
    if academic?
      @client.academic_credit -= @invoice.hours
    else
      @client.test_prep_credit -= @invoice.hours
    end
    @client.save
  end

  def update_invoice_to_paid
    @invoice.status = 'paid'
  end
  
  def client_low_balance?
    if academic?
      @client.academic_credit <= 0.5
    else
      @client.test_prep_credit <= 0.5
    end
  end

  def save_records
    ActiveRecord::Base.transaction do
      @invoice.save!
      @submitter.save!
      @client.save! if @client
    end
  rescue ActiveRecord::RecordInvalid => e
    @errors = e
  end

  private

  def academic?
    @invoice.engagement.academic_type == 'Academic'
  end

  class << self
    def lower_balance_and_update(user, object_to_update)
      user.outstanding_balance -= object_to_update.hours
      object_to_update.status = 'paid'
      ActiveRecord::Base.transaction do
        user.save!
        object_to_update.save!
      end
    end
  end
end
