module PaymentHelper
  def get_suggested_hours(engagement)
      if !(engagement.suggestions.empty?)
        engagement.suggestions.last.hours
      end
  end
end
