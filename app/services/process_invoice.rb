class ProcessInvoice 
  def initialize(invoice_id)
    @invoice = Invoice.find(invoice_id)
    @student = @invoice.student
    @current_user = @invoice.tutor
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