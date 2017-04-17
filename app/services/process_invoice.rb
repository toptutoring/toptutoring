class ProcessInvoice 
  def initialize(invoice, student, user)
    @invoice = invoice
    @student = student
    @current_user = user
  end

  def self.process(invoice_id, student_id, user_id)
    student = User.find(student_id)
    current_user = User.find(user_id)
    invoice = Invoice.find(invoice_id)
    ProcessInvoice.new(invoice, student, current_user).process!
  end 

  def process!
    UpdateUserBalance.new(@invoice.amount, @current_user.id).increase
    if @student.is_student?
      UpdateUserBalance.new(@invoice.amount, @student.id).decrease
      @student.reload
    else
      UpdateUserBalance.new(@invoice.amount, @student.client.id).decrease
      @student.client.reload
    end
    balance = @student.is_student? ? @student.balance.to_f : @student.client.balance.to_f
    return balance
  end
end