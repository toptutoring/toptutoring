class DwollaPaymentService
  class << self
    Result = Struct.new(:success?, :message)

    def charge!(payout)
      request = DwollaService.request(:transfer, transfer_payload(payout))
      if request.success?
        save_payout(payout, request.response)
        SlackNotifier.notify_payout_made(payout)
        Result.new(true, "Payment is being processed.")
      else
        Result.new(false, request.response)
      end
    end

    private

    def transfer_payload(payout)
      {
        _links: {
          destination: {
            href: account_url(payout.destination)
          },
          source: {
            href: source_url(payout.funding_source)
          }
        },
        amount: {
          currency: "USD",
          value: payout.amount
        },
        metadata: {
          concept: payout.description
        }
      }
    end

    def account_url(id)
      "#{ENV.fetch('DWOLLA_API_URL')}/accounts/#{id}"
    end

    def source_url(id)
      "#{ENV.fetch('DWOLLA_API_URL')}/funding-sources/#{id}"
    end

    def save_payout(payout, transfer_url)
      payout.dwolla_transfer_url = transfer_url
      payout.status = "processing"
      payout.save!
    end
  end
end
