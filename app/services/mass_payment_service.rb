class MassPaymentService
  attr_reader :messages, :errors, :payments

  def initialize(type, payer)
    @type = type
    @payer = payer
    @funding_source = FundingSource.last.funding_source_id
    @messages = []
    @errors = []
    @payments = sort_all_pending
  end

  def pay_all
    return if no_payments?
    admin_account_token = DwollaService.admin_account_token
    mass_payment = admin_account_token.post "mass-payments", request_body
    finalize_payments(mass_payment)
  rescue DwollaV2::ValidationError => e
    @errors << e[:code] + ": " + e[:message]
  rescue DwollaV2::Error => e
    @errors << e._embedded.errors.first.message
  rescue OpenSSL::Cipher::CipherError
    @errors << "There was an error with ciphering the access token."
  end

  def update_processing(status)
      paid_users.each do |user|
        if @type == 'invoice'
          update_for_invoice(user, status)
        else
          update_for_timesheet(user, status)
        end
      end
  end

  private

  def sort_all_pending
    if @type == "invoice"
      users_with_pending = Invoice.pending.pluck(:tutor_id).uniq
      sort_invoices users_with_pending
    else
      users_with_pending = Timesheet.pending.pluck(:user_id).uniq
      sort_timesheets users_with_pending
    end
  end

  def sort_invoices(user_ids)
    user_ids.each_with_object([]) do |id, obj|
      user = User.find(id)
      pending_items = user.invoices.pending
      valid_hours = user.outstanding_balance >= pending_items.sum(:hours)
      valid_user = user.has_valid_dwolla? && valid_hours
      add_or_skip_item(obj, valid_user, user, pending_items)
    end
  end

  def sort_timesheets(user_ids)
    user_ids.each_with_object([]) do |id, obj|
      user = User.find(id)
      pending_items = user.timesheets.pending
      valid_user = user.has_valid_dwolla?
      add_or_skip_item(obj, valid_user, user, pending_items)
    end
  end

  def add_or_skip_item(obj, valid_user, user, pending_items)
    if valid_user
      payment = Payment.new(payment_params(user, pending_items))
      pending_items.update_all(status: 'processing')
      obj << payment
    else
      @messages << invalid_user_message(user.name)
    end
  end

  def payment_params(user, pending_items)
    ids = pending_items.pluck(:id).join(', ')
    { amount: pending_items_total_pay(pending_items),
      payee_id: user.id,
      description: "Payment for invoices: #{ids}." }
  end

  def pending_items_total_pay(pending_items)
    if @type == "invoice"
      cents = pending_items.map(&:tutor_pay).reduce(:+).cents
    else
      cents = pending_items.map { |sheet| sheet.amount.cents }.reduce(:+)
    end
    Money.new(cents)
  end

  def invalid_user_message(name)
    "There was an error making a payment for #{name}. Payment was not processed."
  end

  def no_payments?
    return false unless @payments.empty?
    @errors << "There were no payments to be made."
  end

  def request_body
    {
      _links: {
        source: {
          href: source_url(@funding_source)
        }
      },
      items: payments_array
    }
  end

  def payments_array
    return_array = []
    @payments.each do |payment|
      return_array << payment_hash(payment)
    end
    return_array
  end

  def payment_hash(payment)
    {
      _links: {
        destination: {
          href: account_url(User.find(payment.payee_id).auth_uid)
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

  def record_payments
    @payments.each do |payment|
      payment.status = "paid"
      payment.save
    end
  end

  def finalize_payments(mass_payment)
    if mass_payment
      record_payments
      set_final_message
    else
      @errors << "There was an error while processing payment."
    end
  end

  def paid_users
    @payments.map { |item| User.find(item.payee_id) }
  end

  def set_final_message
    total = @payments.map(&:amount).reduce(:+)
    total_formatted = "$#{format('%.2f', total)}"
    size = @payments.size
    start = size == 1 ? "#{size} payment has" : "#{size} payments have"
    @messages << start + " been made for a total of #{total_formatted}."
  end

  def update_for_invoice(user, status)
    processing_invoices = user.invoices.where(status: 'processing')
    user.outstanding_balance -= processing_invoices.sum(:hours) if status =='paid'
    ActiveRecord::Base.transaction do
      processing_invoices.update_all(status: status)
      user.save!
    end
  end

  def update_for_timesheet(user, status)
    processing_timesheets = user.timesheets.where(status: 'processing')
    processing_timesheets.update_all(status: status)
  end
end
