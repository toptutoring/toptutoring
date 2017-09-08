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

  def funding_sources
    response = account_token.get("#{account_url}/funding-sources")
    response._embedded["funding-sources"]
  end

  private

  def account_token
    DWOLLA_CLIENT.auths.client
  end

  def account_url
    account_token.get('/')._links.account.href
  end
end
