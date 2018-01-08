class MassPaymentService
  attr_reader :messages, :errors, :payouts

  def initialize(type, approver)
    @type = type
    @approver = approver
    @funding_source = FundingSource.first
    @messages = []
    @errors = []
    @paid_users = []
    @payouts = convert_all_pending_to_payouts
  end

  def pay_all
    return if no_payouts?
    admin_account_token = DwollaService.admin_account_token
    mass_pay = admin_account_token.post "mass-payments", request_body
    finalize_payouts(mass_pay.headers[:location])
  rescue DwollaV2::ValidationError => e
    @errors << "Dwolla Errors" + e._embedded.errors.to_s
  rescue DwollaV2::Error => e
    @errors << "Dwolla Error: " + e.to_s
  rescue OpenSSL::Cipher::CipherError
    @errors << "OpenSSL Error: There was an error with ciphering the access token."
  end

  def update_processing(status)
    @paid_users.each do |user|
      update_and_adjust_balances(user, status)
    end
  end

  private

  def no_payouts?
    return false unless @payouts.empty?
    @errors << "There were no payouts to be made."
    ping_slack
    true
  end

  def convert_all_pending_to_payouts
    users_to_pay = User.with_pending_invoices(@type)
    create_payouts_for_users(users_to_pay)
  end

  def create_payouts_for_users(users_to_pay)
    users_to_pay.each_with_object([]) do |user, payout_list|
      pending_items = user_pending_items(user)
      valid_hours = user.outstanding_balance >= pending_items.sum(:hours)
      if user.has_valid_dwolla? && valid_hours
        add_to_payouts(payout_list, user, pending_items)
      else
        @messages << invalid_user_message(user.name)
      end
    end
  end

  def user_pending_items(user)
    return user.invoices.by_tutor.pending if @type == "by_tutor"
    user.invoices.by_contractor.pending
  end

  def add_to_payouts(payout_list, user, pending_items)
    payout_list << Payout.new(payout_params(user, pending_items))
    pending_items.update_all(status: "processing")
    @paid_users << user
  end

  def payout_params(user, pending_items)
    ids = pending_items.pluck(:id).join(", ")
    account = @type == "by_tutor" ? user.tutor_account : user.contractor_account
    { amount: pending_items_total_pay(pending_items),
      receiving_account: account, approver: @approver,
      destination: user.auth_uid, funding_source: @funding_source.funding_source_id,
      description: "Payment for invoices: #{ids}." }
  end

  def pending_items_total_pay(pending_items)
    cents = pending_items.sum(:submitter_pay_cents)
    Money.new(cents)
  end

  def invalid_user_message(name)
    "There was an error making a payment for #{name}. Payment was not processed."
  end

  def request_body
    {
      _links: {
        source: {
          href: source_url(@funding_source.funding_source_id)
        }
      },
      items: payouts_array
    }
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
        value: payout.amount
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

  def finalize_payouts(mass_url)
    record_payouts(retrieve_items(mass_url))
    set_final_message
    ping_slack
  end

  def retrieve_items(mass_url)
    items_response = DWOLLA_CLIENT.auths.client.get mass_url + "/items"
    items_response[:_embedded][:items]
  end

  def record_payouts(items)
    @payouts.each do |payout|
      auth_id = payout.payee.auth_uid
      payout_item = items.find { |item| auth_id == item[:metadata][:auth_uid] }
      payout.status = "processing"
      payout.dwolla_transfer_url = payout_item[:_links][:transfer][:href]
      payout.save
    end
  end

  def set_final_message
    total_paid = @payouts.map(&:amount).reduce(:+)
    size = @payouts.size
    start = size == 1 ? "#{size} payment has" : "#{size} payments have"
    @messages << start + " been made for a total of $#{total_paid}."
  end

  def update_and_adjust_balances(user, status)
    processing_invoices = user.invoices.where(status: "processing")
    user.outstanding_balance -= processing_invoices.sum(:hours) if status == "paid"
    ActiveRecord::Base.transaction do
      processing_invoices.update_all(status: status)
      user.save!
    end
  end

  def ping_slack
    messages = @messages.empty? ? nil : "\nMessages\n" + @messages.join("\n")
    error_messages = @errors.empty? ? nil : "\nErrors\n" + @errors.join("\n")
    SlackNotifier.notify_mass_payment_made(messages, error_messages)
  end
end
