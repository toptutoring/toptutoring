class PagesController < ApplicationController
  layout "authentication", only: [:payment, :home, :show]

  def admin_dashboard
    render "admin_dashboard", :layout => false
  end

  def director_dashboard
    render "director_dashboard", :layout => false
  end

  def tutor_dashboard
    render "tutor_dashboard", :layout => false
  end

  def home
    render "www/pages/home"
  end

  def show
    not_found unless valid_page?
    render "www/pages/#{params[:path]}"
  end

  def calendar
    render "calendar", :layout => false
  end

  private

  def valid_page?
    template_exists? "www/pages/#{params[:path]}"
  end
end
