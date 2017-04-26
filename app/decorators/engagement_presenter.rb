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
    @engagement.tutor.try(:name)
  end

  def student_subject
    @engagement.student.student_info.subject
  end

  def student_academic_type
    @engagement.student.student_info.academic_type
  end

  def student_credit
    @engagement.student.client.academic_credit + @engagement.student.client.test_prep_credit
  end

  def hourly_rate
    if self.academic_type.casecmp('academic') == 0
      self.client.academic_rate
    else
      self.client.test_prep_rate
    end
  end
end
