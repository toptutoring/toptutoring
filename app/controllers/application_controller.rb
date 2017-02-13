class ApplicationController < ActionController::Base
  include Clearance::Controller
  protect_from_forgery with: :exception

  if Rails.env.production?
    force_ssl(host: ENV['SSL_APPLICATION_HOST'])
  end
end
