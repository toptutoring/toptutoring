class InvoicePresenter < SimpleDelegator

  def initialize(invoice)
    @invoice = invoice
    super
  end

  def academic_type
    @invoice.assignment.academic_type
  end

  def subject
    @invoice.assignment.subject
  end

  def student_name
    @invoice.assignment.student.name
  end
end
