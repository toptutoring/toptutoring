module ApplicationHelper
  CURRENT_YEAR = "2018"

  def link_to_phone_number(user)
    link_to user.phone_formatted || "", "tel:#{user.phone_formatted(:sanitized)}"
  end

  def cleanup_phone_number(number, country_code = nil)
    phone_number = Phonelib.parse(number, country_code)
    return if phone_number.international.nil?
    tag.a href: "tel:#{phone_number.international.tr(" ", "")}" do 
      phone_number.national 
    end
  end

  def current_year
    CURRENT_YEAR || Date.current.year
  end

  def page_title(page_title = "Top Tutoring")
    content_for :page_title, page_title
  end

  def status_icon(status)
    icon_type = case status
                when "paid" then "ion-checkmark-round text-success"
                when "succeeded" then "ion-checkmark-round text-success"
                when "denied" then "ion-close-round text-danger"
                else "ion-clock text-default"
                end
    tag.i class: "icon #{icon_type}"
  end

  def true_production
    (ENV["DWOLLA_ENVIRONMENT"] == "production") && Rails.env.production?
  end
end
