module TutorHelper
  def tutor_balance(tutor)
    "#{tutor.balance} hrs of tutoring"
  end

  def can_send_email?(student)
    Invoice.where(student_id: student.id).any?
  end
end
