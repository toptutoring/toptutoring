class StripePaymentService
  class << self
    Result = Struct.new(:success?, :message)

    def charge!(payout, invoice)
      client = invoice.client
      transfer = Stripe::Transfer.create({
        :amount => payout.amount_cents,
        :currency => payout.amount_currency.downcase,
        :destination => payout.receiving_account.user.stripe_uid,
        :transfer_group => "#{client.id}_#{client.first_name}_#{client.last_name}"
      })

      if transfer
        save_payout(payout)
        SlackNotifier.notify_payout_made(payout)
        Result.new(true, "Payment is being processed.")
      else
        Result.new(false, "Payment failed for Payout: #{payout.id}")
      end
    rescue Stripe::InvalidRequestError => e
      Result.new(false, "Payment failed for Payout. #{e.message}")
    end

    private

    def save_payout(payout)
      payout.status = "processing"
      payout.save!
    end
  end
end
