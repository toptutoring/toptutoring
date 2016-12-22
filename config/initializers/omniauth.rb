require_relative "../../lib/strategies/dwolla"

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :dwolla, ENV.fetch("DWOLLA_APPLICATION_KEY"), ENV.fetch("DWOLLA_APPLICATION_SECRET")
end

OmniAuth.config.on_failure = Proc.new do |env|
  OmniAuth::FailureEndpoint.new(env).redirect_to_failure
end
