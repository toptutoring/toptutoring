class CreditUpdater
  def initialize(invoice_id)
    @invoice = Invoice.find(invoice_id)
    @engagement = @invoice.engagement
    @client = @engagement.client
    @tutor = @invoice.tutor
  end

  def process!
    update_client_credit
    update_tutor_balance
  end

  def client_balance
    academic? ? @client.academic_credit : @client.test_prep_credit
  end

  private

  def update_client_credit
    if academic?
      @client.academic_credit -= @invoice.hours
    else
      @client.test_prep_credit -= @invoice.hours
    end
    @client.save
  end

  def update_tutor_balance
    @tutor.outstanding_balance += @invoice.hours
    @tutor.save
  end

  def academic?
    @engagement.academic_type.casecmp('academic') == 0
  end
end
