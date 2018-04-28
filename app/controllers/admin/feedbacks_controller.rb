module Admin
  class FeedbacksController < ApplicationController
    def index
      @feedbacks = Feedback.all
      @feedbacks.update_all(read: true)
    end
  end
end
