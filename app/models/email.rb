class Email < ActiveRecord::Base
  # Associations
  belongs_to :tutor, class_name: "User", foreign_key: "tutor_id"
  belongs_to :parent, class_name: "User", foreign_key: "parent_id"

  #Validations
  validates_presence_of :parent_id, :tutor_id, :subject, :body


  def email_subject(invoice)
    "#{invoice.hours} hours of tutoring invoiced by #{invoice.tutor.name}"
  end

  def email_body(invoice, parent)
    "#{invoice.tutor.name} has invoiced #{invoice.hours} hours of tutoring for #{invoice.assignment.subject}. " +
    "You have #{parent.hourly_balance <= 0 ? 0 : parent.hourly_balance} hours left in your hourly balance and payments " +
    "must be made in advance before the next tutoring sessions. Please login to " +
    "https://toptutoring.herokuapp.com to pay for your next sessions."
  end
end
