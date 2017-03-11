module Api
  module Signups
    class TutorsController < ApiController

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
        params.require(:user).permit(:name, :email, :password, tutor_info_attributes: [:academic_type]).merge(access_state: "enabled", roles: :tutor)
      end

    end
  end
end
