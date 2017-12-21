module ClientHelper
  def client_credit(client)
    engagement_types = client.client_account.academic_types_engaged
    if engagement_types.count == 1 && engagement_types.include?("academic")
      "#{client.academic_credit} hrs credit"
    elsif engagement_types.count == 1 && engagement_types.include?("test_prep")
      "#{client.test_prep_credit} hrs credit"
    end
  end
end
