module Api
  module Signups
    class ApiController < ActionController::Base
      respond_to :json
      skip_filter :verify_authenticity_token, :create
      before_action :authenticate_request

      private

      def authenticate_request
        if request.method == 'OPTIONS'
          set_option_access_control_headers
        elsif request.method == 'POST'
          set_post_access_control_headers
        end
      end

      def set_option_access_control_headers
        if request.headers['HTTP_ACCESS_CONTROL_REQUEST_HEADERS'].include?('api_application_key')
          headers['Access-Control-Allow-Origin'] = 'http://www.toptutoring.com'
          headers['Access-Control-Allow-Headers'] = 'api_application_key'
          head 200
        else
          head 401, status: :unauthorized
        end
      end

      def set_post_access_control_headers
        if request.headers['HTTP_API_APPLICATION_KEY'] != ENV.fetch('API_APPLICATION_KEY')
          head 401, status: :unauthorized
        else
          headers['Access-Control-Allow-Origin'] = 'http://www.toptutoring.com'
        end
      end

    end
  end
end
