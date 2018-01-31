module PaymentHelper
  def get_tutor_rate(engagement)
    if engagement.academic?
      engagement.tutor.academic_rate
    else
      engagement.tutor.test_prep_rate
    end
  end
end
