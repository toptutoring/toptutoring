class ApplicationMailer < ActionMailer::Base
  default from: ENV.fetch("MAILER_SENDER")
  layout 'mailer'
end
