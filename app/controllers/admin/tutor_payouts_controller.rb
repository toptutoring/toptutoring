module Admin
  class TutorPayoutsController < ApplicationController
    def index
      @type = "Tutor"
      @payouts = Payout.tutors
                       .order(created_at: :desc)
                       .paginate(page: params[:page], per_page: 10)
    end
  end
end
