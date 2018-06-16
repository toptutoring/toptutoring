module Clients
  class InvoicesController < ApplicationController
    before_action :require_login

    def index
      @invoices = current_user.client_account
                              .invoices
                              .where.not(status: "denied")
                              .order(created_at: :desc)
                              .includes(include_hash)
    end

    private

    def include_hash
      { engagement: [
        { tutor_account: :user },
        { student_account: :user },
        :subject
      ] }
    end
  end
end
