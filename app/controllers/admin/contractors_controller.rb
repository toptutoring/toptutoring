module Admin
  class ContractorsController < ApplicationController
    before_action :require_login

    def index
      @contractors = User.contractors.view_order.includes(:contractor_account)
    end
  end
end
