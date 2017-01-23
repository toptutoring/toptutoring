class InvoiceDecorator < Draper::Decorator
  def academic_type
    object.assignment.academic_type
  end

  def subject
    object.assignment.subject
  end

  def student_name
    object.assignment.student.student.name
  end
end
