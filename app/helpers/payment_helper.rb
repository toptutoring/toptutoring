module PaymentHelper
  def get_tutor_rate(engagement)
    if engagement.academic?
      engagement.tutor.academic_rate
    else
      engagement.tutor.test_prep_rate
    end
  end

  def payment_status_icon(status)
    icon_type = case status
                when "paid" then "ion-checkmark-round text-success"
                when "succeeded" then "ion-checkmark-round text-success"
                when "refunded" then "ion-cash text-default"
                when "refund" then "ion-refresh text-success"
                when "denied" then "ion-close-round text-danger"
                else "ion-clock text-default"
                end
    tag.i class: "icon #{icon_type}"
  end

  def payment_amount_display_text(payment)
    if payment.class == Refund
      "(#{number_to_currency(payment.amount)})"
    else
    number_to_currency(payment.amount)
    end
  end
end
