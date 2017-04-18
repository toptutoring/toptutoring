class EngagementPresenter < SimpleDelegator

  def initialize(engagement)
    @engagement = engagement
    super
  end

  def student_id
    @engagement.student.id
  end

  def student_name
    @engagement.student.name
  end

  def tutor_name
    @engagement.tutor&.name
  end

  def student_subject
    @engagement.student.student_info.subject
  end

  def student_academic_type
    @engagement.student.student_info.academic_type
  end
end
