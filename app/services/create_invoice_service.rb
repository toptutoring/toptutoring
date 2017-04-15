class CreateInvoiceService
  def initialize(invoice_params, student, current_user)
    @invoice = Invoice.new(invoice_params)
    @student = student
    @current_user = current_user
  end
  
  def self.process(invoice_params, student_id, user_id)
    student = User.find(student_id)
    current_user = User.find(user_id)
    CreateInvoiceService.new(invoice_params, student, current_user).process!
  end

  def process!
    if @invoice.save
      UpdateUserBalance.new(@invoice.amount, @current_user.id).increase
      if @student.is_student?
        UpdateUserBalance.new(@invoice.amount, @student.id).decrease
        @student.reload
      else
        UpdateUserBalance.new(@invoice.amount, @student.client.id).decrease
        @student.client.reload
      end
      balance = @student.is_student? ? @student.balance.to_f : @student.client.balance.to_f
      return "success!", balance
    else
      return "failed"
    end
  end
end