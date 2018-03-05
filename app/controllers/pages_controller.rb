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
    if valid_page?
      render "www/pages/#{params[:path]}"
    else
      render "www/pages/404", status: :not_found
    end
  end

  def calendar
    render "calendar", :layout => false
  end

  private

  def valid_page?
    File.exist?(Pathname.new(Rails.root + "app/views/www/pages/#{params[:path]}.html.erb"))
  end
end
