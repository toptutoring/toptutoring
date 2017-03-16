module Api
  module Signups
    class UsersController < ApiController

      def create
        @user = Clearance.configuration.user_model.new(signups_params)
        if @user.save
          render :status => 200, json: {}
        else
          render :status => 422, json: @user.errors.full_messages
        end
      end

      private

      def signups_params
        params.require(:user).permit(:name, :email, :password, client_info_attributes: [:tutoring_for, :subject]).merge(roles: "client")
      end

    end
  end
end
