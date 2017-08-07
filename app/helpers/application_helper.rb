module ApplicationHelper

  def cleanup_phone_number number
    if number.nil? || number.empty?
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
