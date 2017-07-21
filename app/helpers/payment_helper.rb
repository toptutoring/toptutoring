module PaymentHelper

  def get_tutor_rate(engagement)
    if engagement.academic_type == "Academic"
      engagement.tutor.academic_rate_cents/100.0
    else
      engagement.tutor.test_prep_rate_cents/100.0
    end
  end

  def get_suggested_hours(engagement)
      engagement.suggestions.last.suggested_minutes/60.0
  end
end
