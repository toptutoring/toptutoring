module TutorHelper
  def tutor_outstanding_balance(tutor)
    "#{tutor.outstanding_balance} hrs of tutoring"
  end

  def can_send_email?(client)
    Invoice.where(client_id: client.id).any?
  end

  def limit_suggestion_description_length(description)
    if description.length > 70
      "#{description[0..70]}..."
    end
  end
end
