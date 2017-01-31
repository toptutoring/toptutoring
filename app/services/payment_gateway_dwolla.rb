class PaymentGatewayDwolla
  attr_reader :error

  def initialize(payment)
    @payment = payment
    @payer = payment.payer
  end

  def create_transfer
    ensure_valid_token
    begin
      response = account_token.post("transfers", transfer_payload)
      payment.update(external_code: response.headers["location"])
    rescue DwollaV2::Error => e
      @error = e
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
    new_token = DWOLLA_CLIENT.auths.refresh(account_token)
    payer.update(access_token: new_token.access_token,
                refresh_token: new_token.refresh_token,
                token_expires_at: Time.current.to_i + new_token.expires_in)
  end

  def account_token
    DWOLLA_CLIENT.tokens.new(access_token: payer.access_token,
                             refresh_token: payer.refresh_token)
  end
end
