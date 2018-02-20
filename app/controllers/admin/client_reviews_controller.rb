module Admin
  class ClientReviewsController < ApplicationController
    def index
      @clients = User.clients
      @reviews = ClientReview.all
    end

    def create
      client = User.find_by_id(params[:client_id])
      UserNotifierMailer.send_review_request(client)
      flash.notice = "Review has been requested."
      redirect_to admin_client_reviews_path
    end
  end
end
