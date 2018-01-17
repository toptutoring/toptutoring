class DwollaMassPayWorker
  include Sidekiq::Worker
  sidekiq_options retry: 2

  def perform(url)
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
    invoices = payout.invoices
    if item[:status] == "failed"
      invoices.update_all(status: "pending")
      adjust_payout_data(payout, item, "failed")
    else
      invoices.update_all(status: "paid")
      update_and_adjust_balances(invoices, payout.payee)
      adjust_payout_data(payout, item, "paid")
    end
    payout.save!
  end

  def update_and_adjust_balances(invoices, user)
    user.outstanding_balance -= invoices.sum(:hours)
    user.save!
  end

  def adjust_payout_data(payout, item, status)
    payout.status = status
    payout.dwolla_transfer_url = item[:transfer_url]
    payout.dwolla_mass_pay_item_url = item[:item_url]
  end

  def error_finding_payout(item)
    STDOUT.puts "Unable to find payout for mass pay item #{item[:item_url]}."
  end
end
