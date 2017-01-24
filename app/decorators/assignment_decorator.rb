class AssignmentDecorator < Draper::Decorator
  def student_id
    object.student.id
  end

  def student_name
    object.student.student.name
  end

  def tutor_name
    object.tutor.try(:name)
  end

  def student_subject
    object.student.student.subject
  end

  def student_academic_type
    object.student.student.academic_type
  end
end
