module ClientHelper
  def client_credit(client)
    if client.client_engagements&.first&.active?
      "#{client.academic_credit + client.test_prep_credit} hrs credit"
    end
  end
end
