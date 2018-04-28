module ApplicationHelper
  CURRENT_YEAR = "2018"

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
