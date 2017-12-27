class PaymentGatewayDwolla
  attr_reader :error

  def initialize(payout)
    @payout = payout
  end

  def create_transfer
    account_token = DwollaService.admin_account_token
    response = account_token.post("transfers", transfer_payload)
    @payout.dwolla_transfer_url = response.headers["location"]
    @payout.status = "created"
  rescue DwollaV2::Error => e
    Rails.logger.error(e._embedded.errors)
    @error = "Dwolla Error: " + e._embedded.errors.first.message
  rescue OpenSSL::Cipher::CipherError
    @error = "OpenSSL Error: There was an error with ciphering the access token."
  end

  private

  def transfer_payload
    {
      _links: {
        destination: {
          href: account_url(@payout.destination)
        },
        source: {
          href: source_url(@payout.funding_source)
        }
      },
      amount: {
        currency: "USD",
        value: @payout.amount
      },
      metadata: {
        concept: @payout.description
      }
    }
  end

  def account_url(id)
    "#{ENV.fetch("DWOLLA_API_URL")}/accounts/#{id}"
  end

  def source_url(id)
    "#{ENV.fetch("DWOLLA_API_URL")}/funding-sources/#{id}"
  end
end
