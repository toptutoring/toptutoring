class DwollaService

  DWOLLA_WEBHOOK_EVENTS = ["bank_transfer_created",
                          "bank_transfer_cancelled",
                          "bank_transfer_failed",
                          "bank_transfer_completed",
                          "transfer_created",
                          "transfer_cancelled",
                          "transfer_failed",
                          "transfer_reclaimed",
                          "transfer_completed"].freeze

  def initialize
    if ENV.fetch("DWOLLA_ENVIRONMENT") == "production"
      @user = User.admin_payer.first
    else
      @user = User.admin
    end
  end

  def funding_sources
    return [] unless user.has_external_auth?
    ensure_valid_token
    response = account_token.get("#{account_url}/funding-sources")
    response._embedded["funding-sources"]
  end

  private

  attr_reader :user

  def account_token
    DWOLLA_CLIENT.tokens.new(access_token: user.access_token,
                             refresh_token: user.refresh_token)
  end

  def account_url(uid = user.auth_uid)
    "#{ENV.fetch("DWOLLA_API_URL")}/accounts/#{uid}"
  end

  def ensure_valid_token
    return if user.valid_token?
    new_token = DWOLLA_CLIENT.auths.refresh(account_token)
    user.update(access_token: new_token.access_token,
                refresh_token: new_token.refresh_token,
                token_expires_at: Time.current.to_i + new_token.expires_in)
  end
end
