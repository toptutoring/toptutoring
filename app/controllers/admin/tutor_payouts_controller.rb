module Admin
  class TutorPayoutsController < ApplicationController
    def index
      @payouts = Payout.tutors.order(created_at: :desc)
    end
  end
end
