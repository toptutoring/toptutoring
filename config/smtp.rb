SMTP_SETTINGS = {
  user_name: ENV["SENDGRID_USERNAME"],
  password: ENV["SENDGRID_PASSWORD"],
  address: "smtp.sendgrid.net",
  authentication: :plain,
  domain: ENV["APPLICATION_HOST"],
  enable_starttls_auto: true,
  port: "587"
}

if ENV["EMAIL_RECIPIENTS"].present?
  Mail.register_interceptor RecipientInterceptor.new(ENV["EMAIL_RECIPIENTS"])
end
