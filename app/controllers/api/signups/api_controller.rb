module Api
  module Signups
    class ApiController < ActionController::Base
      respond_to :json
      skip_filter :verify_authenticity_token, only: [ :create ]
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
        headers['Access-Control-Allow-Origin'] = 'http://www.toptutoring.com'
        head 200
      end

      def set_post_access_control_headers
        headers['Access-Control-Allow-Origin'] = 'http://www.toptutoring.com'
      end

    end
  end
end
