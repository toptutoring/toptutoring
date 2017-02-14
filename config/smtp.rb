SMTP_SETTINGS = {
  user_name: ENV["SENDGRID_USERNAME"],
  password: ENV["SENDRID_PASSWORD"],
  address: "smtp.sendgrid.net",
  authentication: :plain,
  domain: "heroku.com",
  enable_starttls_auto: true,
  port: "587"
}

if ENV["EMAIL_RECIPIENTS"].present?
  Mail.register_interceptor RecipientInterceptor.new(ENV["EMAIL_RECIPIENTS"])
end
