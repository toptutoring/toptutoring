module Admin
  class StudentAccountsController < ApplicationController
    def destroy
      account = StudentAccount.find(params[:id])
      account.destroy
      flash.notice = "#{account.name}'s student account has been removed."
      redirect_to edit_admin_user_path(account.client)
    rescue ActiveRecord::ActiveRecordError => e
      flash.alert = e.message
      redirect_to edit_admin_user_path(account.client)
    end

    def create
      account = StudentAccount.new(account_params)
      if account.save
        flash.notice = "A new Student Account has been created for #{account.client.name}."
      else
        flash.alert = results.messages
      end
      redirect_to edit_admin_user_path(account.client)
    end

    private

    def account_params
      params.require(:student_account).permit(:client_account_id, :name)
    end
  end
end
