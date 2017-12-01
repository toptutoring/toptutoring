class DwollaTokenRefresh
  def initialize(user_id)
    @user_id = user_id
  end

  def perform
    refresh_token
  rescue ArgumentError => e
    Bugsnag.notify("Error refreshing Dwolla Token: " + e.message)
  end

  private

  def account_token
    DWOLLA_CLIENT.tokens.new(access_token: user.access_token,
                             refresh_token: user.refresh_token)
  end

  def refresh_token
    new_token = DWOLLA_CLIENT.auths.refresh(account_token)
    user.update(dwolla_access_token: new_token.access_token,
                dwolla_refresh_token: new_token.refresh_token,
                token_expires_at: Time.current.to_i + new_token.expires_in)
  end

  def user
    @user ||= User.find(@user_id)
  end
end
