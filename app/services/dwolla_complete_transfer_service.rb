class DwollaCompleteTransferService
  class << self
    def perform!(url, status)
      ActiveRecord::Base.transaction do
        payout = Payout.find_by(dwolla_transfer_url: url)
        if payout
          update_payout(payout, status)
        else
          Rails.logger.info "Could not find processing payout with transfer url: #{url}"
        end
      end
    end

    def update_payout(payout, status)
      if payout.status == "processing"
        invoices = payout.invoices.where(status: "processing")
        update_invoices_and_user(payout.payee, invoices, status)
        payout.update!(status: status)
      else
        Rails.logger.info "Payout #{payout.id} is not processing. Current status: #{payout.status}."
      end
    end

    def update_invoices_and_user(user, invoices, status)
      return invoices.update_all(status: "paid") if status == "paid"
      hours = invoices.sum(:hours)
      user.outstanding_balance += hours
      user.save!
      invoices.update_all(status: "pending")
    end
  end
end
