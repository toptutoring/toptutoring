module Tutors
  class PayoutsController < ApplicationController
    before_action :require_login

    def index
      if current_user.stripe_uid.present?
        @account = Stripe::Account.retrieve("#{current_user.stripe_uid.to_s}")
        @balance = Stripe::Balance.retrieve()
        stripe_object = @account.external_accounts.data.first
        @bank_account = stripe_object if stripe_object.object == "bank_account"
        @card = stripe_object if stripe_object.object == "card"
      end
    end
  end
end
