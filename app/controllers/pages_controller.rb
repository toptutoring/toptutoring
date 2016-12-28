class PagesController < ApplicationController

  def admin_dashboard
    render "admin_dashboard", :layout => false
  end

  def director_dashboard
    render "director_dashboard", :layout => false
  end

  def tutor_dashboard
    render "tutor_dashboard", :layout => false
  end

  def calendar
    render "calendar", :layout => false
  end
end
