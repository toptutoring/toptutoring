class AuthSetupController < ApplicationController
  ADMIN_SCOPE = "accountinfofull|email|transactions|send|funding".freeze
  DEFAULT_SCOPE = "accountinfofull".freeze

  def setup
    scope = admin? ? ADMIN_SCOPE : DEFAULT_SCOPE
    request.env['omniauth.strategy'].options[:scope] = scope
    render plain: "Setup Complete", status: 404
  end
end
