class DwollaCompleteTransferService
  class << self
    def perform!(event)
      payout = event.payout
      return update_payout(payout, event.payout_status) if payout 
      Rails.logger.warn "Failure - Could not find processing payout with transfer url: #{event.resource_url}"
      false
    end
    
    private

    def update_payout(payout, status)
      Rails.logger.info "Updating payout #{payout.id} to #{status}."
      if payout.update_status_and_invoices(status)
        Rails.logger.info "Success - Updated payout #{payout.id} to #{payout.status}."
        true
      else
        Rails.logger.warn "Failure - Unable to update payout #{payout.id} to #{payout.status}."
        false
      end
    end
  end
end
