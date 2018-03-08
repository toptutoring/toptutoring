module Tutors
  class TutorProfilesController < ApplicationController
    def show
      @tutor_account = current_user.tutor_account
      ids = @tutor_account.exam_subjects.ids
      @subjects = Subject.test_prep.where.not(id: ids)
    end

    def update
      @tutor_account = current_user.tutor_account
      if @tutor_account.update(profile_params)
        flash.now.notice = "Your public profile has been updated."
      else
        flash.now.alert = @tutor_account.errors.full_messages
      end
    end

    def post_picture
      @tutor_account = current_user.tutor_account
      if @tutor_account.update(picture_params)
        flash.notice = "Your public profile picture has been updated."
      else
        flash.alert = @tutor_account.errors.full_messages
      end
      redirect_to action: :show
    end

    def remove_picture
      @tutor_account = current_user.tutor_account
      @tutor_account.remove_profile_picture!
      if @tutor_account.save
        flash.notice = "Your profile picture has been removed."
      else
        flash.alert = @tutor_account.errors.full_messages
      end
      redirect_to action: :show
    end

    private

    def profile_params
      params.require(:tutor_account)
            .permit(:description, :short_description)
    end

    def picture_params
      params.require(:tutor_profile)
        .permit(:profile_picture)
    end
  end
end
