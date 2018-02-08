module Clients
  class PaymentMethodsController < ApplicationController
    before_action :require_login

    def index
      account = current_user.stripe_account
      @payment_methods = account ? account.sources : []
    end

    def create
      result = StripeAccountService.create_account!(current_user, token)
      flash_message(result)
      redirect_to action: :index
    end

    private

    def token
      params.require(:stripe_token)
    end


    def flash_message(result)
      if result.success?
        flash.notice = result.message
      else
        flash.alert = result.message
      end
    end
  end
end
