module PaymentHelper

  def get_tutor_rate(engagement)
    if !(engagement.tutor.nil?)
      if engagement.academic_type == "Academic"
        engagement.tutor.academic_rate_cents/100.0
      else
        engagement.tutor.test_prep_rate_cents/100.0
      end
    end
  end

  def get_suggested_hours(engagement)
      if !(engagement.suggestions.nil?)
        engagement.suggestions.last.hours
      end
  end
end
