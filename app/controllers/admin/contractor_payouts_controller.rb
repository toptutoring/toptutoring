module Admin
  class ContractorPayoutsController < ApplicationController
    def index
      @type = "Contractor"
      @payouts = Payout.contractors
                       .order(created_at: :desc)
                       .paginate(page: params[:page], per_page: 10)
      render "admin/tutor_payouts/index"
    end
  end
end
