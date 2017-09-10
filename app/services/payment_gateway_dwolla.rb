class PaymentGatewayDwolla
  attr_reader :error

  def initialize(payment)
    @payment = payment
  end

  def create_transfer
    account_token = DwollaService.admin_account_token
    begin
      response = account_token.post("transfers", transfer_payload)
      @payment.external_code = response.headers["location"]
      @payment.status = "created"
    rescue DwollaV2::Error => e
      @error = e._embedded.errors.first.message
    end
  end

  private

  def transfer_payload
    {
      _links: {
        destination: {
          href: account_url(@payment.destination)
        },
        source: {
          href: source_url(@payment.source)
        }
      },
      amount: {
        currency: "USD",
        value: @payment.amount
      },
      metadata: {
        concept: @payment.description
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
