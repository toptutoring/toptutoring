class StripePaymentService
  class << self
    Result = Struct.new(:success?, :message)

    def charge!(payout, invoice)
      if invoice.submitter_type == "by_contractor"
        agent = invoice.submitter
      else
        agent = invoice.client
      end
      transfer = Stripe::Transfer.create({
        :amount => payout.amount_cents,
        :currency => payout.amount_currency.downcase,
        :destination => payout.receiving_account.user.stripe_uid,
        :transfer_group => "#{agent.id}_#{agent.first_name}_#{agent.last_name}"
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
