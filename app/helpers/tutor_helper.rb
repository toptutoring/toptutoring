module TutorHelper
  def tutor_outstanding_balance(tutor)
    "#{tutor.outstanding_balance} hrs of tutoring"
  end

  def can_send_email?(client)
    Invoice.where(client_id: client.id).any?
  end
end
