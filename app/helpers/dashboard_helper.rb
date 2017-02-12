module DashboardHelper
  def dwolla_message
    "Hello #{current_user.name}, your #{ current_user.is_director? ? 'administrator' : 'director' } 
      is using Dwolla in order to make transfers. Please click the button below to authenticate with Dwolla."
  end
end
