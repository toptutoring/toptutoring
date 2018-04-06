class PagesController < ApplicationController
  layout "authentication"

  def home
    render "www/pages/home"
  end

  def show
    not_found unless valid_page?
    render "www/pages/#{params[:path]}"
  end

  private

  def valid_page?
    template_exists? "www/pages/#{params[:path]}"
  end
end
