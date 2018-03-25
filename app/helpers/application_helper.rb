module ApplicationHelper
  CURRENT_YEAR = "2018"

  def link_to_phone_number(user)
    link_to user.phone_formatted || "", "tel:#{user.phone_formatted(:sanitized)}"
  end

  def cleanup_phone_number number
    Phonelib.parse(number, :us).national
  end

  def current_year
    CURRENT_YEAR || Date.current.year
  end
end
