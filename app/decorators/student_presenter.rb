class StudentPresenter < SimpleDelegator
  def initialize(student)
    @student = student
    super
  end

  def client
    @client ||= @student.client_id ? @student.client : @student
  end

  def client_id
    client.id
  end

  def test_prep_rate
    client.test_prep_credit
  end

  def academic_credit
    client.academic_credit.to_s
  end

  def academic_type
    client.client_engagements.pluck(:academic_type).uniq
  end
end
