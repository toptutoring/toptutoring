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

  def student_name
    @invoice.engagement.student.name
  end
end
