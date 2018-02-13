class MassPaymentService
  Result = Struct.new(:success?, :message)

  def initialize(users, approver, type)
    # Addtional attributes are added to the User object in ActiveRecord Query
    # Each occurence has been commented
    # See User.with_pending_invoices_attributes for more detail
    @funding_source = FundingSource.first
    @messages = []
    prepare_payouts_and_invoices(users, approver, type)
  end

  def pay_all
    return no_payments_error if @payouts.empty?
    request = DwollaService.request(:mass_payment, request_body)
    if request.success?
      finalize_payouts(request.response)
      Result.new(true, @messages)
    else
      @invoices.update_all(payout_id: nil, status: "pending")
      @payouts.destroy_all
      Result.new(false, request.response)
    end
  end

  private

  def prepare_payouts_and_invoices(users, approver, type)
    sort_valid_and_invalid_users(users)
    new_payouts = approver.approved_payouts.create(payouts_params(type))
    @payouts = approver.approved_payouts.where(id: new_payouts.map(&:id))
    @invoices = Invoice.where(payout: @payouts)
    @invoices.update_all(status: "processing")
  end

  def no_payments_error
    no_payments_message
    Result.new(false, @messages)
  end

  def no_payments_message
    @messages << "No payments were made."
  end

  def sort_valid_and_invalid_users(users)
    invalid_users = users.having("auth_uid IS NULL")
    create_invalid_messages(invalid_users) if invalid_users.any?
    @valid_users = users.having("auth_uid IS NOT NULL")
  end

  def create_invalid_messages(invalid_users)
    @messages = invalid_users.map do |user|
      "Payment could not be processed for #{user.name}."
    end
  end

  def payouts_params(type)
    account_type = type == "by_tutor" ? :tutor_account : :contractor_account
    @valid_users.map do |user|
      # invoice_to_pay_ids and amount_cents are added using User.with_pending_invoices_attributes
      { amount_cents: user.amount_cents, invoice_ids: user.invoice_to_pay_ids,
        receiving_account: user.send(account_type), status: "processing",
        destination: user.auth_uid, funding_source: @funding_source.funding_source_id,
        description: "Payment for invoices: #{user.invoice_to_pay_ids.join(', ')}." }
    end
  end

  def request_body
    { _links: { source: { href: @funding_source.url } },
      items: payouts_array }
  end

  def payouts_array
    @payouts.map do |payout|
      payout_hash(payout)
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

  def finalize_payouts(url)
    @payouts.update_all(dwolla_mass_pay_url: url)
    final_message
  end

  def final_message
    size = @payouts.count
    if size >= 1
      message_of_payments_paid(size)
    else
      no_payments_message
    end
    SlackNotifier.notify_mass_payment_made(@messages)
  end

  def message_of_payments_paid(size)
    total_paid = Money.new(@payouts.sum(&:amount_cents))
    start = size == 1 ? "#{size} payment has" : "#{size} payments have"
    @messages << start + " been made for a total of $#{total_paid}."
  end
end
