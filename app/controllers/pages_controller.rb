class PagesController < ApplicationController

  def director_dashboard
    render "director_dashboard", :layout => false
  end

  def calendar
    render "calendar", :layout => false
  end
end
