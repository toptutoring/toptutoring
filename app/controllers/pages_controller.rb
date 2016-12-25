class PagesController < ApplicationController

  def example_dashboard
    render "example_dashboard", :layout => false
  end

  def calendar
    render "calendar", :layout => false
  end
end
