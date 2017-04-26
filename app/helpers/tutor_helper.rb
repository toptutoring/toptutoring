module TutorHelper
  def tutor_outstanding_balance(tutor)
    "#{tutor.out_standing_balance} hrs of tutoring"
  end

  def can_send_email?(student)
    Invoice.where(student_id: student.id).any?
  end
end
