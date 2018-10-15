class AuthCallbacksController < ApplicationController
  before_action :require_login

  def create
    # code indicates the authorization code
    # {"code"=>"ac_DmUySFrKuLFKthKiQQrQH8RlMpor1quU", "state"=>"7bc7d77698ec3f2e", "controller"=>"auth_callbacks", "action"=>"create", "provider"=>"stripe"}
    if dwolla_auth_hash.present?
      AuthHashService.new(dwolla_auth_hash).update_dwolla_attributes(current_user)
    else
      options = {
        site: 'https://connect.stripe.com',
        response_type: "code",
        authorize_url: '/oauth/authorize',
        token_url: '/oauth/token'
      }
      code = params[:code]
      client = OAuth2::Client.new(ENV['STRIPE_CONNECT_CLIENT_ID'], ENV['STRIPE_SECRET_KEY'], options)
      @resp = client.auth_code.get_token(code, :params => {:scope => 'read_write'})
      @access_token = @resp.token
      @refresh_token = @resp.refresh_token
      current_user.update!(stripe_uid: @resp.params["stripe_user_id"]) if @resp
      flash[:notice] = "Your account has been successfully created and is ready to process payments!"
    end

    redirect_to dashboard_path
  end

  private

  def dwolla_auth_hash
    request.env["omniauth.auth"]
  end
end
