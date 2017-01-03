module Api
  module Signups
    class TutorsController < ActionController::Base
      respond_to :json
      skip_filter :verify_authenticity_token, :create
      before_filter :authenticate_request

      def create
        user = User.find_by(email: signups_params[:email])
        if user
          render :status => 422, json: "Email already in use!"
        else
          @user = Clearance.configuration.user_model.new(signups_params)
          if @user.save
            head 200
          else
            render :status => 422, json: @user.errors
          end
        end
      end

      private

      def signups_params
        params.require(:user).permit(:name, :email, :password, tutor_attributes: [:academic_type])
      end

      def authenticate_request
        render nothing: true, status: :unauthorized if request.headers['HTTP_API_APPLICATION_KEY'] != ENV.fetch('API_APPLICATION_KEY')
      end

    end
  end
end
