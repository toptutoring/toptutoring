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
    return [] unless User.admin.auth_uid.present?
    response = account_token.get funding_sources_url
    response._embedded["funding-sources"]
  end

  private

  def funding_sources_url
    ENV.fetch('DWOLLA_API_URL') + '/accounts/' + auth_uid + '/funding-sources'
  end

  def auth_uid
    return ENV.fetch('DWOLLA_DEV_ADMIN_AUTH_UID') if Rails.env.development?
    User.admin.auth_uid
  end

  def account_token
    DWOLLA_CLIENT.auths.client
  end
end
