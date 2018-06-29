module ApplicationHelper
  CURRENT_YEAR = "2018"

  def current_year
    CURRENT_YEAR || Date.current.year
  end

  def page_title(page_title = "Top Tutoring")
    content_for :page_title, page_title
  end

  def true_production
    (ENV["DWOLLA_ENVIRONMENT"] == "production") && Rails.env.production?
  end

  def icon_link(path, icon, tooltip, id, classes: nil)
    concat(link_to(path, id: id, class: "fs-24 #{classes}") do 
      tag.i class: "icon #{icon}",
            data: { toggle: "tooltip", placement: "top", "original-title" => tooltip }
    end)
  end

  def render_icon_confirm_link(icon, tooltip, path, id, confirm_title: "Confirm", confirm_message: "Are you sure?", classes: nil, link_method: :get, remote: false, warning: false)
    concat(link_to("", id: id, class: classes, onclick: "showConfirmModal(event, '#{confirm_title}', '#{confirm_message}', '#{path}', '#{link_method}', #{remote}, '#{warning}');")do
      tag.i(class: "icon #{icon} fs-24 text-primary",
            data: { toggle: "tooltip", placement: "top", "original-title" => tooltip })
    end)
  end

  def render_confirm_link(link_text, path, id, confirm_title: "Confirm", confirm_message: "Are you sure?", classes: nil, link_method: :get, remote: false, warning: false)
    concat(link_to(
             link_text, "",
             id: id,
             class: classes,
             onclick: "showConfirmModal(event, '#{confirm_title}', '#{confirm_message}', '#{path}', '#{link_method}', #{remote}, '#{warning}');"))
  end
end
