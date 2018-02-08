module Clients
  class PaymentMethodsController < ApplicationController
    before_action :require_login

    def index
      account = current_user.stripe_account
      @payment_methods = account ? account.sources : []
    end
end
