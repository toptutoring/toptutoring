class CreateInvoice
  def initialize(invoice_params, student, current_user)
    @invoice = Invoice.new(invoice_params)
    @student = student
    @current_user = current_user
  end
  
  def self.process(invoice_params, student_id, user_id)
    student = User.find(student_id)
    current_user = User.find(user_id)
    CreateInvoice.new(invoice_params, student, current_user).process!
  end

  def process!
    if @invoice.save
      return @invoice.id
    else
      return false
    end
  end
end