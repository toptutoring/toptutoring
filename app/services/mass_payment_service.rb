class MassPaymentService
  Result = Struct.new(:success?, :message)

  def initialize(user_invoices, approver)
    @messages = []
    @user_invoices = user_invoices
    @approver = approver
    @funding_source_id = FundingSource.first.funding_source_id
    @payouts = create_payouts
  end

  def pay_all
    return no_payments if @payouts.empty?
    request = DwollaService.request(:mass_payment, request_body)
    if request.success?
      finalize_payouts(DwollaService.request(:mass_pay_items, request.response))
      Result.new(true, @messages)
    else
      ids = @user_invoices.values.flatten.map(&:id)
      Invoice.where(id: ids).update_all(status: "pending")
      Result.new(false, request.response)
    end
  end

  private

  def no_payments
    @messages << "No payments made"
    Result.new(false, @messages)
  end

  def create_payouts
    @user_invoices.each_with_object([]) do |(user, invoices), obj|
      if user.outstanding_balance >= invoices.sum(&:hours)
        add_to_payouts(user, invoices, obj)
      else
        @messages << invalid_user_message(user.name)
      end
    end
  end

  def add_to_payouts(user, invoices, obj)
    ids = invoices.map(&:id)
    total_cents = invoices.sum(&:submitter_pay_cents)
    account = invoices.last.by_tutor? ? user.tutor_account : user.contractor_account
    obj << Payout.new(payout_params(user, total_cents, account, ids))
    invoices_update(ids, "processing")
  end

  def payout_params(user, total_cents, account, ids)
    { amount_cents: total_cents, receiving_account: account, approver: @approver,
      destination: user.auth_uid, funding_source: @funding_source_id,
      description: "Payment for invoices: #{ids.join(', ')}." }
  end

  def invalid_user_message(name)
    "There was an error making a payment for #{name}. Payment was not processed."
  end

  def request_body
    { _links: { source: { href: source_url(@funding_source_id) } },
      items: payouts_array }
  end

  def payouts_array
    @payouts.each_with_object([]) do |payout, result_array|
      result_array << payout_hash(payout)
    end
  end

  def payout_hash(payout)
    {
      _links: {
        destination: {
          href: account_url(payout.destination)
        }
      },
      amount: {
        currency: "USD",
        value: payout.amount.to_s
      },
      metadata: {
        auth_uid: payout.payee.auth_uid,
        payee_id: payout.payee.id,
        approver_id: payout.approver_id,
        description: payout.description
      }
    }
  end

  def account_url(id)
    "#{ENV.fetch('DWOLLA_API_URL')}/accounts/#{id}"
  end

  def source_url(id)
    "#{ENV.fetch('DWOLLA_API_URL')}/funding-sources/#{id}"
  end

  def finalize_payouts(request)
    if request.success?
      record_payouts(request.response)
    else
      @messages << "Unable to set transfer url. " + request.response
      record_payouts
    end
    set_final_messages_and_notifications
  end

  def record_payouts(items = [])
    @payouts.each do |payout|
      id = payout.payee.auth_uid
      item = items.find { |pay_item| pay_item[:metadata][:auth_uid] == id }
      update_payout(payout, item)
    end
  end

  def update_payout(payout, item)
    if item[:status] == "failed"
      @messages << "Payment failed for #{payout.payee.name}"
      invoices_update(@user_invoices[payout.payee].map(&:id), "pending")
    else
      payout.dwolla_transfer_url = item[:_links][:transfer][:href]
      payout.status = "paid"
      update_and_adjust_balances(payout.payee)
      payout.save!
  end

  def update_and_adjust_balances(user)
    invoices = @user_invoices[user]
    user.outstanding_balance -= invoices.sum(&:hours)
    invoices_update(invoices.map(&:id), "paid")
    user.save!
  end

  def invoices_update(ids, status)
    Invoice.where(id: ids).update_all(status: status)
  end

  def set_final_messages_and_notifications
    @payouts.select! { |payout| payout.status == "paid" }
    total_paid = @payouts.map(&:amount).reduce(:+)
    size = @payouts.size
    start = size == 1 ? "#{size} payment has" : "#{size} payments have"
    @messages << start + " been made for a total of $#{total_paid}."
    SlackNotifier.notify_mass_payment_made(@messages)
  end
end
