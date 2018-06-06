class ClientReviewsController < ApplicationController
  before_action :set_user
  layout "authentication", only: :email_new

  def create
    @review = @user.client_account.client_reviews.build(review_params)
    if @review.save
      SlackNotifier.ping("A new review of #{@review.stars} stars has been submitted by #{@user.full_name}.", :leads)
      AdminDirectorNotifierMailer.notify_review_made(@user, @review).deliver_later
    else
      flash.now.alert = I18n.t("app.clients.reviews.error")
    end
  end

  def update
    @review = @user.client_account.client_reviews.find(params[:id])
    if @review.update(update_params)
      @updated = true
    else
      flash.now.alert = I18n.t("app.clients.reviews.error")
    end
    render "create"
  end

  private

  def set_user
    @user ||= current_user || user_by_token
  end

  def user_by_token
    User.find_by(unique_token: params.require(:unique_token))
  end

  def review_params
    params.require(:client_review)
          .permit(:stars)
          .merge(review_link: review_link,
                 review_source: review_source)
  end

  def update_params
    params.require(:client_review)
          .permit(:review, :permission_to_publish)
  end

  def review_link
    @user.client_account.review_link || ENV.fetch("DEFAULT_REVIEW_LINK")
  end

  def review_source
    @user.client_account.review_source || ENV.fetch("DEFAULT_REVIEW_SOURCE")
  end
end
