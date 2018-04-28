module Admin
  class TutorAccountsController < ApplicationController
    before_action :require_login
    before_action :set_tutor_account, only: [:update, :edit]

    def update
      if @tutor_account.update_attributes(publish: publish_params)
        flash.now[:notice] = "Updated tutor's profile"
      else
        flash.now[:alert] = @tutor_account.errors.full_messages
      end
    end

    def badge
      @score = TutorAccount.find(params[:tutor_account_id])
                           .test_scores.find(params[:badge_id])          
      @score.badge = @score.badge ? nil : "Badge"
      if @score.save
        write_flash(@score)
      else
        flash.now[:alert] = "Unable to update badge status for score."
      end
    end

    private

    def select_tutors
      @tutors = @tutors.joins(tutor_account: :subjects)
                       .where(subjects: { id: @subject_id })
    end

    def publish_params
      params.require(:publish)
    end

    def write_flash(score)
      return flash.now[:notice] = "Badge has been added." if score.badge
      flash.now[:notice] = "Badge has been removed."
    end

    def set_tutor_account
      @tutor_account = TutorAccount.find(params[:id])
    end
  end
end
