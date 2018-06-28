module Admin
  class TutorPayoutsController < ApplicationController
    def index
      @type = "Tutor"
      @payouts = Payout.tutors
                       .order(created_at: :desc)
    end
  end
end
