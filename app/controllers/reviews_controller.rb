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
      flash.now[:notice] = "Thank you for your review!"
      SlackNotifier.ping("A new review has been submitted by #{@reviewer.full_name}.", :leads)
      AdminDirectorNotifierMailer.notify_review_made(@reviewer, @review).deliver_later
    else
      flash.now[:alert] = "Sorry. There was a problem while submitting your review."
    end
  end

  private

  def review_params
    params.require(:client_review)
          .permit(:stars, :description, :review, :permission_to_publish)
  end

  def set_reviewer
    @reviewer = User.clients.find_by(unique_token: token)
    return if @reviewer
    flash.alert = "The requested resource does not exist."
    redirect_to sign_in_path
  end

  def token
    params.require(:unique_token)
  end
end
