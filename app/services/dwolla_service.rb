class DwollaService
  class << self
    # Enable webhooks. Runs during instantiation and only for production.
    if ENV["DWOLLA_ENVIRONMENT"] == "production" && Rails.env.production?
      app_token = DWOLLA_CLIENT.auths.client

      # Delete all current webhooks
      webhooks = app_token.get "webhook-subscriptions"

      webhooks._embedded["webhook-subscriptions"].each do |subscription|
        app_token.delete subscription._links[:self][:href]
      end

      # Create new webhook
      subscription_request_body = {
        url: "https://app.toptutoring.com/dwolla/webhooks",
        secret: ENV.fetch("DWOLLA_WEBHOOK_SECRET")
      }

      app_token.post "webhook-subscriptions", subscription_request_body
    end

    Response = Struct.new(:success?, :response)

    def request(resource, *args)
      send(resource, *args)
    rescue DwollaV2::ValidationError => e
      Response.new(false, e._embedded.errors.map { |error| error_text(error) })
    rescue DwollaV2::AccessDeniedError => e
      Response.new(false, e.error.titlecase + ": " + e.error_description)
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
      Response.new(true, response.response_headers[:location])
    end

    def mass_pay_items(url)
      response = account_token(User.admin).get(url + "/items")
      items_array = response._embedded.items.map do |item|
        item_hash = { auth_uid: item[:metadata][:auth_uid],
                      status: item[:status],
                      item_url: item._links[:self][:href] }
        item_hash[:transfer_url] = item._links[:transfer][:href] if item._links[:transfer]
        item_hash
      end
      Response.new(true, items_array)
    end

    def transfer(payload)
      response = refresh_token!(User.admin).post("transfers", payload)
      Response.new(true, response.response_headers["location"])
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
