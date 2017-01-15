module Api
  module Signups
    class TutorsController < ApiController

      def create
        @user = Clearance.configuration.user_model.new(signups_params)
        if @user.save
          head 200
        else
          render :status => 422, json: @user.errors.full_messages
        end
      end

      private

      def signups_params
        params.require(:user).permit(:name, :email, :password, tutor_attributes: [:academic_type])
      end

    end
  end
end
