class DwollaMassPayUpdateService
  class << self
    def perform!(url)
      request = DwollaService.request(:mass_pay_items, url)
      if request.success?
        payouts = Payout.where(dwolla_mass_pay_url: url, status: "processing")
        update_payouts(payouts, request.response)
      else
        record_payouts
      end
    end

    private

    def update_payouts(payouts, items)
      ActiveRecord::Base.transaction do
        items.each do |item|
          payout = payouts.find_by(destination: item[:auth_uid])
          if payout
            save_payout(payout, item)
          else
            error_finding_payout(item)
          end
        end
      end
    end

    def save_payout(payout, item)
      if item[:status] == "failed"
        invoices = payout.invoices.where(status: "processing")
        update_invoices_and_user(payout.payee, invoices)
        payout.status = "failed"
      end
      adjust_payout_data(payout, item)
      payout.save!
    end

    def update_invoices_and_user(user, invoices)
      hours = invoices.sum(:hours)
      user.outstanding_balance += hours
      user.save!
      invoices.update_all(status: "pending")
    end

    def adjust_payout_data(payout, item)
      payout.dwolla_transfer_url = item[:transfer_url]
      payout.dwolla_mass_pay_item_url = item[:item_url]
    end

    def error_finding_payout(item)
      Rails.logger.info "Unable to find payout for mass pay item #{item[:item_url]}."
    end
  end
end
