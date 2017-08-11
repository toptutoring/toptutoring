module DashboardHelper
  def dwolla_message
    "Hello #{current_user.name}, your #{ current_user.has_role?("director") ? 'administrator' : 'director' }
      is using Dwolla in order to make transfers. Please click the button below to authenticate with Dwolla."
  end

  def any_engagements_active? engagements
    engagements.each do |engagement|
      if engagement.active?
        return true
      end
    end
  false
  end
end
