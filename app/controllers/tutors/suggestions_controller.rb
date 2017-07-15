module Tutors
  class SuggestionsController < ApplicationController
    before_action :require_login
    before_action :authorize_tutor, only: :create

    def create
      @suggestion = @engagement.suggestions.new(suggestion_params)
      if @suggestion.save
        redirect_to tutors_students_path, notice: 'Your suggestion has been recorded' and return
      else
        redirect_back(fallback_location: (request.referer || root_path),
                      flash: { error: @suggestion.errors.full_messages }) and return
      end
    end
    private

    def suggestion_params
      suggested_minutes = (params[:suggestion][:hours].to_f * 60).to_i
      params.require(:suggestion)
            .except(:hours)
            .permit(:description, :engagement_id)
            .merge(suggested_minutes: suggested_minutes)
    end

    def authorize_tutor
      if active_engagements.pluck(:id).include?(params[:suggestion][:engagement_id].to_i)
        @engagement = set_engagement
      else
        redirect_back(fallback_location: (request.referer || root_path),
                      flash: { error: "There was an error while submitting your suggestion." }) and return
      end
    end

    def active_engagements
      current_user.tutor_engagements.where(state: "active")
    end

    def set_engagement
      current_user.tutor_engagements.find(params[:suggestion][:engagement_id])
    end
  end
end
