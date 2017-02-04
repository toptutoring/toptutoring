class TutorMailer < ActionMailer::Base
  include SendGrid

  def perform(email_id)
    set_params(email_id) &&
    set_email &&
    send_email
  end

  private

  def set_params(email_id)
    @email = ActiveRecord::Base::Email.find(email_id)
    @sender = @email.tutor
    @receiver = @email.parent.email
  end

  def set_email
    @mail = Mail.new
    @mail.from = Email.new(email: ENV['MAILER_SENDER'])
    personalization = Personalization.new
    personalization.to = Email.new(email: @receiver)
    personalization.substitutions = Substitution.new(key: '-subject-', value: @email.subject )
    personalization.substitutions = Substitution.new(key: '-body-', value: @email.body )
    @mail.personalizations = personalization
    @mail.template_id = ENV['TUTOR_TEMPLATE_ID']
  end

  def send_email
    sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'])
    begin
      response = sg.client.mail._("send").post(request_body: @mail.to_json)
    rescue Exception => e
      puts e.message
    end
  end
end
