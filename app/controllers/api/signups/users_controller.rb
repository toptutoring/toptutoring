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
        params.require(:user).permit(:name, :email, :password, student_info_attributes: [:academic_type]).merge(roles: :client)
      end

    end
  end
end
