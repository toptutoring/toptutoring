class Email < ActiveRecord::Base
  # Associations
  belongs_to :tutor, class_name: "User", foreign_key: "tutor_id"
  belongs_to :client, class_name: "User", foreign_key: "client_id"

  #Validations
  validates_presence_of :client_id, :tutor_id, :subject, :body


  def email_subject(invoice)
    "#{invoice.hours} hours of tutoring invoiced by #{invoice.tutor.name}"
  end

  def email_body(invoice, client, student)
    "#{invoice.tutor.name} has invoiced #{invoice.hours} hours of tutoring for #{invoice.engagement.subject}. " +
    "You have #{client.hourly_balance(student) <= 0 ? 0 : client.hourly_balance(student)} hours left in your hourly balance and payments " +
    "must be made in advance before the next tutoring sessions."
  end
end
