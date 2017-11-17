class MassPaymentService
  attr_reader :messages, :errors, :payments

  def initialize(type, approver)
    @type = type
    @approver = approver
    @funding_source = FundingSource.first
    @messages = []
    @errors = []
    @paid_users = []
    @payments = convert_all_pending_to_payments
  end

  def pay_all
    return if no_payments?
    admin_account_token = DwollaService.admin_account_token
    admin_account_token.post "mass-payments", request_body
    finalize_payments
  rescue DwollaV2::ValidationError => e
    @errors << e[:code] + ": " + e[:message]
  rescue DwollaV2::Error => e
    @errors << e._embedded.errors.first.message
  rescue OpenSSL::Cipher::CipherError
    @errors << "OpenSSL Error: There was an error with ciphering the access token."
  end

  def update_processing(status)
    @paid_users.each do |user|
      update_and_adjust_balances(user, status)
    end
  end

  private

  def no_payments?
    return false unless @payments.empty?
    @errors << "There were no payments to be made."
  end

  def convert_all_pending_to_payments
    users_to_pay = User.with_pending_invoices(@type)
    create_payments_for_users(users_to_pay)
  end

  def create_payments_for_users(users_to_pay)
    users_to_pay.each_with_object([]) do |user, payment_list|
      pending_items = user_pending_items(user)
      valid_hours = user.outstanding_balance >= pending_items.sum(:hours)
      if user.has_valid_dwolla? && valid_hours
        add_to_payments(payment_list, user, pending_items)
      else
        @messages << invalid_user_message(user.name)
      end
    end
  end

  def user_pending_items(user)
    return user.invoices.by_tutor.pending if @type == 'by_tutor'
    user.invoices.by_contractor.pending
  end

  def add_to_payments(payment_list, user, pending_items)
    payment = Payment.new(payment_params(user, pending_items))
    payment_list << payment
    pending_items.update_all(status: 'processing')
    @paid_users << user
  end

  def payment_params(user, pending_items)
    ids = pending_items.pluck(:id).join(', ')
    { amount: pending_items_total_pay(pending_items),
      payee: user, payer: @funding_source.user, approver: @approver,
      destination: user.auth_uid, source: @funding_source.funding_source_id,
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
      items: payments_array
    }
  end

  def payments_array
    @payments.each_with_object([]) do |payment, result_array|
      result_array << payment_hash(payment)
    end
  end

  def payment_hash(payment)
    {
      _links: {
        destination: {
          href: account_url(payment.payee.auth_uid)
        }
      },
      amount: {
        currency: "USD",
        value: payment.amount
      },
      metadata: {
        payment1: payment.description
      }
    }
  end

  def account_url(id)
    "#{ENV.fetch('DWOLLA_API_URL')}/accounts/#{id}"
  end

  def source_url(id)
    "#{ENV.fetch('DWOLLA_API_URL')}/funding-sources/#{id}"
  end

  def finalize_payments
    record_payments
    set_final_message
  end

  def record_payments
    @payments.each do |payment|
      payment.status = "paid"
      payment.save
    end
  end

  def set_final_message
    total_paid = @payments.map(&:amount).reduce(:+)
    size = @payments.size
    start = size == 1 ? "#{size} payment has" : "#{size} payments have"
    @messages << start + " been made for a total of $#{total_paid}."
  end

  def update_and_adjust_balances(user, status)
    processing_invoices = user.invoices.where(status: 'processing')
    user.outstanding_balance -= processing_invoices.sum(:hours) if status == 'paid'
    ActiveRecord::Base.transaction do
      processing_invoices.update_all(status: status)
      user.save!
    end
  end
end
