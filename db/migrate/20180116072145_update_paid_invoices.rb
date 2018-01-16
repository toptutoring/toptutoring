class UpdatePaidInvoices < ActiveRecord::Migration[5.1]
  def up
    user = User.find_by(id: 90, name: "Ki Park", email: "kidonpark828@berkeley.edu")
    return unless user
    paid_invoices = user.invoices.where(status: "processing")
    create_payout(user, paid_invoices)
    update_balances(user, paid_invoices.sum(:hours))
    update_invoices(paid_invoices)
  end

  private 

  def create_payout(user, paid_invoices)
    total_paid = paid_invoices.sum(:submitter_pay_cents)
    Payout.create!(receiving_account: user.tutor_account,
                   amount_cents: total_paid,
                   approver: User.admin, status: "paid",
                   destination: user.auth_uid,
                   funding_source: FundingSource.last.funding_source_id,
                   description: "Payment for invoices: #{paid_invoices.ids.join(", ")}.")
    STDOUT.puts "Created payout for invoices ##{paid_invoices.ids}."
  end

  def update_balances(user, hours)
    user.outstanding_balance -= hours
    user.save!
    STDOUT.puts "Updated user ##{user.id}'s outstanding_balance to #{user.outstanding_balance}."
  end

  def update_invoices(paid_invoices)
    paid_invoices.find_each do |invoice|
      invoice.update!(status: "paid")
      STDOUT.puts "Updated invoice ##{invoice.id} to paid."
    end
  end
end
