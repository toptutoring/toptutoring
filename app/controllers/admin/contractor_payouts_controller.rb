module Admin
  class ContractorPayoutsController < ApplicationController
    def index
      @type = "Contractor"
      @payouts = Payout.contractors
                       .order(created_at: :desc)
      render "admin/tutor_payouts/index"
    end
  end
end
