module ApplicationHelper

  def cleanup_phone_number number
    Phonelib.parse(number, :us).national
  end
end
