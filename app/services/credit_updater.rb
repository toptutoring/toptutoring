class CreditUpdater 
  def initialize(invoice_id)
    @invoice_id = invoice_id 
  end

  def process!
    decrease_client_credit
  end 

  private

  def invoice 
    @invoice ||= Invoice.find(@invoice_id)
  end

  def engagement 
    @engagement ||= invoice.engagement
  end

  def client
    @client ||= engagement.client
  end

  def tutor
    @tutor ||= invoice.tutor
  end

  def decrease_client_credit
    if engagement.academic_type.casecmp('academic') == 0
      client.academic_credit -= invoice.hours
      client.academic_credit
    else
      client.test_prep_credit -= invoice.hours
      client.academic_credit
    end
    client.save

    tutor.outstanding_balance += invoice.hours
    tutor.save

    engagement.academic_type.casecmp('academic') == 0 ? client.academic_credit : client.test_prep_credit
  end
end