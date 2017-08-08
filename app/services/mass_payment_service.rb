class MassPaymentService
  attr_reader :messages, :errors, :pending_items

  def initialize(type, payer)
    @type = type
    @payer = payer
    @funding_source = FundingSource.last.funding_source_id
    @messages = []
    @errors = []
    @pending_items = sort_all_pending
    @payments = change_to_payments # array of invoices or timesheets
    @token = DWOLLA_CLIENT.auths.client
  end

  def pay_all
    return if no_payments?
    mass_payment = @token.post "mass-payments", request_body
    finalize_payments(mass_payment)
  rescue DwollaV2::Error => e
    @errors << e._embedded.errors.first.message
  rescue DwollaV2::ValidationError => e
    @errors << e[:code] + ": " + e[:message]
  end

  def update_pending_to_paid
    @pending_items.each do |item|
      if @type == 'invoice'
        update_for_invoice(item)
      else
        User.find(item.user_id).timesheets.pending.update_all(status: "paid")
      end
    end
  end

  private

  def sort_all_pending
    if @type == "invoice"
      sql = "tutor_id, string_agg(id::text, ', ') AS description, sum(tutor_pay_cents) AS tutor_pay_cents, sum(hours) AS hours"
      sort_invoices Invoice.pending.select(sql).group(:tutor_id)
    else
      sql = "user_id, string_add(id::text) AS description, sum(minutes) AS minutes"
      sort_timesheets Timesheet.pending.select(sql).group(:user_id)
    end
  end

  def sort_invoices(invoices)
    invoices.each_with_object([]) do |invoice, obj|
      user = User.find(invoice.tutor_id)
      valid_user = user.has_valid_dwolla? && user.outstanding_balance >= invoice.hours
      add_or_skip_item(invoice, obj, valid_user, user)
    end
  end

  def sort_timesheets(timesheets)
    timesheets.each_with_object([]) do |sheet, obj|
      user = User.find(sheet.user_id)
      valid_user = user.has_valid_dwolla?
      add_or_skip_item(sheet, obj, valid_user, user)
    end
  end

  def add_or_skip_item(item, obj, valid_user, user)
    if valid_user
      obj << item
    else
      @messages << invalid_user_message(user.name)
    end
  end

  def invalid_user_message(name)
    "There was an error making a payment for #{name}. Payment was not processed."
  end

  def change_to_payments
    @pending_items.map do |item|
      payment = item.to_payment
      payment.payer_id = @payer.id
      payment.source = @funding_source
      payment.description.prepend("Payment for #{@type}s: ")
      payment
    end
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

  def set_final_message
    total = @payments.map(&:amount).reduce(:+)
    total_formatted = "$#{format('%.2f', total)}"
    size = @payments.size
    start = size == 1 ? "#{size} payment has" : "#{size} payments have"
    @messages << start + " been made for a total of #{total_formatted}."
  end

  def update_for_invoice(invoice)
    user = User.find(invoice.tutor_id)
    user.invoices.pending.update_all(status: "paid")
    user.outstanding_balance -= invoice.hours
    user.save
  end
end
