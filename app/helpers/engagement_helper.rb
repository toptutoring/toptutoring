module EngagementHelper
  def client_info(engagement)
    concat tag.p "Student: #{engagement.student_name}"
    concat tag.p "Client: #{engagement.client.full_name}"
  end

  def subject_info(engagement)
    return concat tag.p "Other" if engagement.subject_id == 1
    concat tag.p engagement.academic_type.titlecase
    concat tag.p engagement.subject.name.titlecase
  end

  def rates_and_credits(engagement)
    client = engagement.client
    if engagement.academic?
      concat tag.p "Online: #{rate_credit_string(client, "online_academic")}"
      concat tag.p "In-Person: #{rate_credit_string(client, "in_person_academic")}"
    else
      concat tag.p "Online: #{rate_credit_string(client, "online_test_prep")}"
      concat tag.p "In-Person: #{rate_credit_string(client, "in_person_test_prep")}"
    end
  end

  def rate_credit_string(client, type)
    rate = client.send(type + "_rate")
    credit = client.send(type + "_credit")
    "#{rate} / #{credit}"
  end

  def client_credits(engagement)
    client = engagement.client
    if engagement.academic?
      concat tag.p "Online: #{client.online_academic_credit}" if engagement.rate_for?("online")
      concat tag.p "In-Person: #{client.in_person_academic_credit}" if engagement.rate_for?("in_person")
    else
      concat tag.p "Online: #{client.online_test_prep_credit}" if engagement.rate_for?("online")
      concat tag.p "In-Person: #{client.in_person_test_prep_credit}" if engagement.rate_for?("in_person")
    end
  end
end
