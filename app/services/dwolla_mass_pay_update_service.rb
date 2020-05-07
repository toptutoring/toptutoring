class DwollaMassPayUpdateService
  class << self
    def perform!(event)
      # request = DwollaService.request(:mass_pay_items, event.resource_url)
      # if request.success?
      #   payouts = event.mass_pay_payouts
      #   update_payouts(payouts, request.response)
      # else
      #   record_payouts
      # end
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
      payout.update_status_and_invoices("failed") if item[:status] == "failed"
      payout.dwolla_transfer_url = item[:transfer_url]
      payout.dwolla_mass_pay_item_url = item[:item_url]
      payout.save!
      Rails.logger.info "Updated payout with mass pay item url #{item[:item_url]}."
    end

    def error_finding_payout(item)
      Rails.logger.warn "Unable to find payout for mass pay item #{item[:item_url]}."
    end
  end
end
