module DashboardHelper
  def dwolla_message
    "Hello #{current_user.name}, your #{ current_user.has_role?("director") ? 'administrator' : 'director' }
      is using Dwolla in order to make transfers. Please click the button below to authenticate with Dwolla."
  end

  def credit_widget_display(types, user)
    capture do
      types.each do |type|
        concat balance_string(type, user)
      end
    end
  end

  def balance_string(type, user)
    prefix = type.humanize.capitalize + " Credit: "
    online = "online_#{type}"
    in_person = "in_person_#{type}"
    if current_user.send(online + "_rate") > 0
      content_tag :p, "Online " + prefix + user.send(online + "_credit").to_s, class: "lead"
    elsif current_user.send(in_person + "_rate") > 0
      content_tag :p, "In-Person " + prefix + user.send(in_person + "_credit").to_s, class: "lead"
    end
  end
end
