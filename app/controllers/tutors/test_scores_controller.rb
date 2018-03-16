module Tutors
  class TestScoresController < ApplicationController
    def create
      @score = TestScore.new(score_params)
      if @score.save
        flash.now[:notice] = "Your score has been recorded."
      else
        flash.now[:alert] = "Your score could not be recorded"
      end
    end

    def destroy
      @score = TestScore.find(params[:id])
      if @score.destroy
        flash.now[:notice] = "Your score has been removed."
      else
        flash.now[:alert] = "Your score could not be removed"
      end
    end

    private

    def score_params
      params.require(:test_score)
            .permit(:subject_id, :score)
            .merge(tutor_account: current_user.tutor_account)
    end
  end
end
