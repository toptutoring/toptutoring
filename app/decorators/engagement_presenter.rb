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

  def tutor_name
    @engagement.tutor.try(:name)
  end

  def student_subject
    @engagement.student.student_info.subject
  end

  def engagement_academic_type
    if @engagement.academic_type && @engagement.academic_type.casecmp('academic') == 0
      'Academic'
    else
      'Test Preparation'
    end
  end

  def student_academic_type
    @engagement.student.student_info.academic_type
  end

  def student_credit
    @engagement.student.client.academic_credit + @engagement.student.client.test_prep_credit
  end

  def hourly_rate
    if self.academic_type.casecmp('academic') == 0
      MultiCurrencyAmount.from_cent(self.client.academic_rate.cents, MultiCurrencyAmount::APP_DEFAULT_CURRENCY)
    else
      MultiCurrencyAmount.from_cent(self.client.test_prep_rate.cents, MultiCurrencyAmount::APP_DEFAULT_CURRENCY)
    end
  end
end
