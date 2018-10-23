unless defined? STRIPE_JS_HOST
  STRIPE_JS_HOST = 'https://js.stripe.com/v3/'
end

Stripe.api_version = "2018-09-24"

Stripe.api_key = ENV.fetch("STRIPE_SECRET_KEY")
