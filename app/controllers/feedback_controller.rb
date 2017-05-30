class FeedbackController < ApplicationController

  def create

    @feedback = current_user.feedbacks.build(comments: params[:feedback][:comments])
    if @feedback.save
      flash[:notice] = "Your feedback has been received. Thank you!"
      redirect_to dashboard_path
    else
      flash[:danger] = "There was an error handling your comment."
      redirect_to dashboard_path
    end
  end
end
