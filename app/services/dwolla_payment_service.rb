class DwollaPaymentService
  class << self
    Result = Struct.new(:success?, :message)

    def charge!(payout)
      Result.new(false, "Dwolla not supported")
      # request = DwollaService.request(:transfer, transfer_payload(payout))
      # if request.success?
      #   save_payout(payout, request.response)
      #   SlackNotifier.notify_payout_made(payout)
      #   Result.new(true, "Payment is being processed.")
      # else
      #   Result.new(false, request.response)
      # end
    end
    # Stripe::Payout.create({
    #   :amount => 50,
    #   :currency => "usd",
    #   :destination => User.find(13).stripe_uid
    # })

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
          description: "Top Tutoring payment for invoice ##{payout.invoices.ids}."
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
