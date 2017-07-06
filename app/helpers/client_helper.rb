module ClientHelper
  def client_credit(client)
    if client.client_engagements&.first&.active?
      "#{client.academic_credit + client.test_prep_credit} hrs credit"
    end
  end

  def cleanup_phone_number number
    if number.nil?
      "No phone number listed."
    else
      extract_phone_number(number)
    end
  end

  private

  def extract_phone_number number
    extracted_num = number.split(//).map {|x| x[/\d+/]}.compact.join("")
    "(#{extracted_num[0..2]}) #{extracted_num[3..5]}-#{extracted_num[6..9]}"
  end


end
