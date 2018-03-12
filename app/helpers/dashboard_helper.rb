module DashboardHelper
  def dwolla_message
    "Hello #{current_user.full_name}, your #{ current_user.has_role?("director") ? 'administrator' : 'director' }
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
    prefix = type.titlecase + " Credit: "
    if current_user.send(type + "_rate") > 0
      content_tag :p, prefix + user.send(type + "_credit").to_s
    end
  end
end
