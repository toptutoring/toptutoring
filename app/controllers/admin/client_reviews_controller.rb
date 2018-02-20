module Admin
  class ClientReviewsController < ApplicationController
    def index
      @clients = User.clients
      @reviews = ClientReview.all
    end
end
