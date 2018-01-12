class DwollaService
  class << self
    DWOLLA_WEBHOOK_EVENTS = ["bank_transfer_created",
                             "bank_transfer_cancelled",
                             "bank_transfer_failed",
                             "bank_transfer_completed",
                             "transfer_created",
                             "transfer_cancelled",
                             "transfer_failed",
                             "transfer_reclaimed",
                             "transfer_completed"].freeze

    Response = Struct.new(:success?, :response)

    def request(resource, *args)
      send(resource, *args)
    rescue DwollaV2::ValidationError => e
      Response.new(false, e._embedded.errors.map { |error| error_text(error) })
    rescue DwollaV2::Error => e
      Response.new(false, error_text(e))
    rescue OpenSSL::Cipher::CipherError
      Response.new(false, "There was an error with OpenSSL.")
    end

    def refresh_token!(user)
      new_token = DWOLLA_CLIENT.auths.refresh(account_token(user))
      user.update(access_token: new_token.access_token,
                  refresh_token: new_token.refresh_token,
                  token_expires_at: Time.current + new_token.expires_in)
      new_token
    end

    private

    def mass_payment(payload)
      response = refresh_token!(User.admin).post("mass-payments", payload)
      Response.new(true, response.headers[:location])
    end

    def mass_pay_items(url)
      response = account_token(User.admin).get(url + "/items")
      Response.new(true, response[:_embedded][:items])
    end

    def transfer(payload)
      response = refresh_token!(User.admin).post("transfers", payload)
      Response.new(true, response.headers["location"])
    end

    def funding_sources(user)
      return Response.new(false, "User must authenticate with Dwolla") unless user.auth_uid
      url = api_url + "/accounts/" + user.auth_uid + "/funding-sources"
      response = account_token(user).get url
      Response.new(true, response._embedded["funding-sources"])
    end

    def account_token(user)
      DWOLLA_CLIENT.tokens.new(access_token: user.access_token,
                               refresh_token: user.refresh_token)
    end

    def error_text(error)
      error[:code] + ": " + error[:message]
    end
    
    def api_url
      ENV.fetch("DWOLLA_API_URL")
    end
  end
end
