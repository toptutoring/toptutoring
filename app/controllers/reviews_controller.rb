class ReviewsController < ApplicationController
  layout "authentication"
  before_action :set_reviewer

  def new
    if @reviewer.client_account.client_review
      @review = @reviewer.client_account.client_review
      render :submitted 
    else
      @review = ClientReview.new
    end
  end

  def create
    @review = @reviewer.client_account.build_client_review(review_params)
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

  def set_reviewer
    if token
      @reviewer = User.find_by(unique_token: token)
      return if @reviewer
    end
    flash.alert = "The requested resource does not exist."
    redirect_to sign_in_path
  end

  def token
    return false unless params[:token]
    params.require(:token)
  end
end
