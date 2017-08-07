module TutorHelper

  SUGGESTION_DESCRIPTION_LENGTH_LIMIT = 70

  def tutor_outstanding_balance(tutor)
    "#{tutor.outstanding_balance} hrs of tutoring"
  end

  def can_send_email?(client)
    Invoice.where(client_id: client.id).any?
  end

  def limit_suggestion_description_length(description)
    if description.length > SUGGESTION_DESCRIPTION_LENGTH_LIMIT
      "#{description[0..SUGGESTION_DESCRIPTION_LENGTH_LIMIT]}..."
    else
      description
    end
  end
end
