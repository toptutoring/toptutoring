class CreateInvoice
  def initialize(invoice_params)
    @invoice = Invoice.new(invoice_params)
  end

  def process!
    if @invoice.save
      return @invoice.id
    else
      return @invoice
    end
  end
end