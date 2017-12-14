module Clients
  class InvoicesController < ApplicationController
    before_action :require_login

    def index
      include_hash = { engagement: [
        { tutor_account: :user },
        { student_account: :user },
        :subject
      ] }
      @invoices = current_user.client_account
                              .invoices
                              .includes(include_hash)
    end
  end
end
