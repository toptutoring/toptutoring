class ProcessInvoice 
  def initialize(invoice_id)
    @invoice_id = invoice_id 
  end

  def process!
    increate_tutor_balance && decrease_user_balance && current_balance
  end 

  private

  def invoice 
    @invoice ||= Invoice.find(@invoice_id)
  end

  def student 
    @student ||= invoice.student
  end

  def current_user
    @current_user ||= invoice.tutor
  end

  def increate_tutor_balance
    UpdateUserBalance.new(invoice.amount, current_user).increase
  end

  def decrease_user_balance
    if student.is_student?
      UpdateUserBalance.new(invoice.amount, student.id).decrease && student.reload
    else
      UpdateUserBalance.new(invoice.amount, student.client.id).decrease && student.client.reload
    end
  end

  def current_balance
    balance = student.is_student? ? student.balance.to_f : student.client.balance.to_f
  end
end