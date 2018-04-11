module Admin
  class ContractorPayoutsController < ApplicationController
    def index
      @payouts = Payout.contractors.order(created_at: :desc)
    end
  end
end
