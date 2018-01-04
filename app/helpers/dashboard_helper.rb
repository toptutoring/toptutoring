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
    prefix = type == "academic" ? "Academic Credits: " : "Test Prep Credits: "
    content_tag :p, prefix + user.send(type + "_credit").to_s, class: "lead"
  end
end
