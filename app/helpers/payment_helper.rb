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
                when "refund" then "ion-refresh text-danger"
                when "denied" then "ion-close-round text-danger"
                else "ion-clock text-default"
                end
    tag.i class: "icon #{icon_type}"
  end

  def stripe_connect_auth_link
    base_url = "https://connect.stripe.com/express/oauth/authorize?&client_id="
    csrf_hash = "&state=#{SecureRandom.hex(8)}"
    business_type = "&stripe_user[business_type]=individual"
    first_name = "&stripe_user[first_name]=#{current_user.first_name}"
    last_name = "&stripe_user[last_name]=#{current_user.last_name}"
    email = "&stripe_user[email]=#{current_user.email}"
    URI.encode(base_url + ENV.fetch("STRIPE_CONNECT_CLIENT_ID") + csrf_hash + business_type + first_name + last_name + email)
  end

  def payment_amount_display_text(payment)
    if payment.class == Refund
      "(#{number_to_currency(payment.amount)})"
    else
    number_to_currency(payment.amount)
    end
  end
end
