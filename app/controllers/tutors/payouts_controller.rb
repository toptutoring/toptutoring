module Tutors
  class PayoutsController < ApplicationController
    before_action :require_login

    def index
      if current_user.stripe_uid.present?
        @account = Stripe::Account.retrieve("#{current_user.stripe_uid.to_s}")
        @balance = Stripe::Balance.retrieve()
        @card = @account.external_accounts.data.first
      end
    end
  end
end
