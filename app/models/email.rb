class Email < ActiveRecord::Base
  # Associations
  belongs_to :tutor, class_name: "User", foreign_key: "tutor_id"
  belongs_to :client, class_name: "User", foreign_key: "client_id"

  #Validations
  validates_presence_of :client_id, :tutor_id, :subject, :body


  def email_subject(invoice)
    "#{invoice.hours} hours of tutoring invoiced by #{invoice.tutor.full_name}"
  end

  def email_body(invoice, client)
    "#{invoice.tutor.full_name} has invoiced #{invoice.hours} hours of tutoring for #{invoice.engagement.subject.name}. " +
    "You have #{client.credit_status(invoice) <= 0 ? 0 : client.credit_status(invoice)} hours left in your hourly balance and payments " +
    "must be made in advance before the next tutoring sessions."
  end
end
