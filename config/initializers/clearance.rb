Clearance.configure do |config|
  config.mailer_sender = ENV.fetch("MAILER_SENDER")
  config.rotate_csrf_on_sign_in = true
end
