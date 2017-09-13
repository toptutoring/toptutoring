class EngagementPresenter < SimpleDelegator

  def initialize(engagement)
    @engagement = engagement
    super
  end

  def student_id
    @engagement.student.id
  end

  def student_name
    @engagement.student_name
  end

  def client_name
    @engagement.client.name
  end

  def tutor_name
    @engagement.tutor.try(:name)
  end

  def subject
    @engagement.subject
  end

  def engagement_academic_type
    if @engagement.academic_type && @engagement.academic_type.casecmp('academic') == 0
      'Academic'
    else
      'Test Preparation'
    end
  end

  def student_academic_type
    @engagement.academic_type
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

  def text_for_edit_button
    @engagement.tutor_id.nil? ? "Assign tutor" : "Edit"
  end
end
