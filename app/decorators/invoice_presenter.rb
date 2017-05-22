class InvoicePresenter < SimpleDelegator

  def initialize(invoice)
    @invoice = invoice
    super
  end

  def academic_type
    @invoice.engagement.academic_type
  end

  def subject
    @invoice.engagement.subject
  end

  def client_name
    @invoice.engagement.client.name
  end
end
