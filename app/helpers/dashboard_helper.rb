module DashboardHelper
  def dwolla_message
    "Hello #{current_user.name}, your #{ current_user.has_role?("director") ? 'administrator' : 'director' }
      is using Dwolla in order to make transfers. Please click the button below to authenticate with Dwolla."
  end

  def credit_widget_display(types, user)
    capture do
      concat content_tag :h3, "Online"
      types.each do |type|
        concat balance_string(type, user, "online")
      end
      concat content_tag :h3, "In-Person"
      types.each do |type|
        concat balance_string(type, user, "in_person")
      end
    end
  end

  def balance_string(type, user, session_type)
    prefix = type == "academic" ? "Academic Credits: " : "Test Prep Credits: "
    content_tag :p, prefix + user.send(session_type + "_" + type + "_credit").to_s, class: "lead"
  end
end
