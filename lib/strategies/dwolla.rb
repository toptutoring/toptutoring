module OmniAuth
  module Strategies
    class Dwolla < OmniAuth::Strategies::OAuth2
      DWOLLA_LANDING = "login"

      option :name, "dwolla"
      option :client_options, {
        site: ENV.fetch("DWOLLA_URL"),
        authorize_url: "/oauth/v2/authenticate",
        token_url: "/oauth/v2/token"
      }

      uid { access_token.params["account_id"] }

      def callback_url
        full_host + script_name + callback_path
      end

      def authorize_params
        super.tap do |params|
          params[:dwolla_landing] ||= DWOLLA_LANDING
        end
      end
    end
  end
end
