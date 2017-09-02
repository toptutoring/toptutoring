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
    @user = User.admin
  end

  def funding_sources
    return [] unless @user.has_valid_dwolla?
    response = account_token.get("#{account_url}/funding-sources")
    response._embedded["funding-sources"]
  end

  private

  attr_reader :user

  def account_token
    DWOLLA_CLIENT.auths.client
  end

  def account_url(uid = user.auth_uid)
    "#{ENV.fetch("DWOLLA_API_URL")}/accounts/#{uid}"
  end
end
