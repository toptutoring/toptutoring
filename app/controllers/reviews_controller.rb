class ReviewsController < ApplicationController
  before_action :require_login

  def new
    if current_user.client_account.client_review
      @review = current_user.client_account.client_review
      render :submitted 
    else
      @review = ClientReview.new
    end
  end

  def create
    @review = current_user.client_account.build_client_review(review_params)
    if @review.save
      flash.notice = "Thank you for your review!"
      render :submitted
    else
      flash.alert = "Sorry. There was a problem while submitting your review."
      render :new
    end
  end

  private

  def review_params
    params.require(:client_review).permit(:stars, :description, :review)
  end
end
