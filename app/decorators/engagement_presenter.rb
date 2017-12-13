class EngagementPresenter < SimpleDelegator

  def initialize(engagement)
    @engagement = engagement
    super
  end

  def client_balance
    results = []
    academic_credit = @engagement.client.academic_credit
    test_prep_credit = @engagement.client.test_prep_credit
    if !academic_credit.zero?
      results << "A: #{academic_credit.to_s} hrs"
    end

    if !test_prep_credit.zero?
      results << "TP: #{test_prep_credit.to_s} hrs"
    end
    results.join("<br>")
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
    @engagement.subject.name
  end

  def engagement_academic_type
    @engagement.academic_type.humanize
  end

  def student_academic_type
    @engagement.academic_type.humanize
  end

  def student_credit
    @engagement.student.client.academic_credit + @engagement.student.client.test_prep_credit
  end

  def hourly_rate
    if self.academic?
      self.client.academic_rate
    else
      self.client.test_prep_rate
    end
  end

  def text_for_edit_button
    @engagement.tutor_account_id.nil? ? "Assign tutor" : "Edit"
  end
end
