module Admin
  class ContractorsController < ApplicationController
    before_action :require_login

    def index
      @contractors = User.contractors.view_order.includes(:contractor_account)
    end

    def update
      account = User.find(params[:id]).contractor_account
      if account.update(account_params)
        flash.notice = "Hourly rate has been updated."
      else
        flash.alert = account.errors.full_messages
      end
      redirect_to edit_admin_user_path(account.user)
    end

    private

    def account_params
      params.require(:contractor_account).permit(:hourly_rate)
    end
  end
end
