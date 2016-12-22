require "omniauth-oauth2"

module OmniAuth
  module Strategies
    class Dwolla < OmniAuth::Strategies::OAuth2
      DEFAULT_SCOPE = "accountinfofull|email|transactions|send|funding"
      DWOLLA_LANDING = "login"

      option :name, "dwolla"
      option :client_options, {
        site: ENV.fetch("DWOLLA_URL"),
        authorize_url: "/oauth/v2/authenticate",
        token_url: "/oauth/v2/token"
      }

      uid { access_token.params["account_id"] }

      info do
        {
          "name"  => user["Name"],
          "email" => user_email["Email"],
        }
      end

      def callback_url
        full_host + script_name + callback_path
      end

      def authorize_params
        super.tap do |params|
          params[:scope] ||= DEFAULT_SCOPE
          params[:dwolla_landing] ||= DWOLLA_LANDING
        end
      end

      def client
        if $testing_mode
          options[:client_id] = ENV.fetch("SANDBOX_DWOLLA_APPLICATION_KEY")
          options[:client_secret] = ENV.fetch("SANDBOX_DWOLLA_APPLICATION_SECRET")
          options[:client_options][:site] = ENV.fetch("SANDBOX_DWOLLA_URL")
        end
        super
      end

      private

      def user
        @user ||= access_token.get("/oauth/rest/users/").parsed["Response"]
      end

      def user_email
        @user_email ||= access_token.get("/oauth/rest/users/email").parsed["Response"]
      end
    end
  end
end
