class AssignmentPresenter < SimpleDelegator

  def initialize(assignment)
    @assignment = assignment
    super
  end

  def student_id
    @assignment.student.id
  end

  def student_name
    @assignment.student.name
  end

  def tutor_name
    @assignment.tutor&.name
  end

  def student_subject
    @assignment.student.student_info.subject
  end

  def student_academic_type
    @assignment.student.student_info.academic_type
  end
end
