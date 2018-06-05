module Admin
  class ClientReviewsController < ApplicationController
    def index
      @clients = User.clients
      @reviews = ClientReview.all
    end

    def create
      client = User.find_by_id(params[:user_id])
      UserNotifierMailer.send_review_request(client).deliver_later
      flash.notice = "Review for #{client.full_name} has been requested."
      redirect_to admin_client_reviews_path
    end

    def destroy
      @review = ClientReview.find(params[:id])
      if @review.destroy
        flash.now.notice = "Review has been removed."
      else
        flash.now.alert = "Review could not be removed."
      end
    end
  end
end
