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

  def self.funding_sources
    return [] unless User.admin.auth_uid.present?
    response = admin_account_token.get funding_sources_url
    response._embedded["funding-sources"]
  rescue DwollaV2::Error => e
    Bugsnag.notify("Error retrieving funding_sources for admin: " + e.message)
    []
  rescue OpenSSL::Cipher::CipherError
    []
  end

  def self.admin_account_token
    DwollaTokenRefresh.new(User.admin.id).perform
    # https://github.com/Dwolla/dwolla-v2-ruby#dwollav2token
    DWOLLA_CLIENT.tokens.new(access_token: User.admin.access_token)
  end

  class << self
    private

    def funding_sources_url
      ENV.fetch('DWOLLA_API_URL') + '/accounts/' + auth_uid + '/funding-sources'
    end

    def auth_uid
      return ENV.fetch('DWOLLA_DEV_ADMIN_AUTH_UID') if Rails.env.development?
      User.admin.auth_uid
    end
  end
end
