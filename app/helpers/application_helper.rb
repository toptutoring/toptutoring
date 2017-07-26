module ApplicationHelper

  def get_subject_name subject_id
    if is_numeric?(subject_id)
      Subject.find(subject_id).name
    else
      subject_id
    end
  end

  def cleanup_phone_number number
    if number.nil? || number.empty?
      "No phone number listed."
    else
      extract_phone_number(number)
    end
  end

  private

  def is_numeric?(val)
    true if Integer(val) rescue false
  end

  def extract_phone_number number
    extracted_num = number.split(//).map {|x| x[/\d+/]}.compact.join("")
    "(#{extracted_num[0..2]}) #{extracted_num[3..5]}-#{extracted_num[6..9]}"
  end

end
