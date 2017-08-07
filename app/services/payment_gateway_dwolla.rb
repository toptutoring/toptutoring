class PaymentGatewayDwolla
  attr_reader :error

  def initialize(payment)
    @payment = payment
    @payer = User.admin
  end

  def create_transfer
    unless payer.has_valid_dwolla?
      payer.reset_dwolla_tokens
      @error = "Admin must authenticate with Dwolla before making a payment"
      return
    end
    ensure_valid_token
    begin
      response = account_token.post("transfers", transfer_payload)
      payment.external_code = response.headers["location"]
      payment.status = "created"
    rescue DwollaV2::Error => e
      @error = e._embedded.errors.first.message
    end
  end

  private

  attr_reader :payer, :payment

  def transfer_payload
    {
      _links: {
        destination: {
          href: account_url(payment.destination)
        },
        source: {
          href: source_url(payment.source)
        }
      },
      amount: {
        currency: "USD",
        value: payment.amount
      },
      metadata: {
        concept: payment.description
      }
    }
  end

  def account_url(id)
    "#{ENV.fetch("DWOLLA_API_URL")}/accounts/#{id}"
  end

  def source_url(id)
    "#{ENV.fetch("DWOLLA_API_URL")}/funding-sources/#{id}"
  end

  def ensure_valid_token
    return if payer.valid_token?
    DwollaTokenRefresh.new(payer.id).perform
  end

  def account_token
    DWOLLA_CLIENT.tokens.new(access_token: payer.access_token,
                             refresh_token: payer.refresh_token)
  end
end
