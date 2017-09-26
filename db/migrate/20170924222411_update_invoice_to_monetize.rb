class UpdateInvoiceToMonetize < ActiveRecord::Migration[5.1]
  def up
    remove_column :invoices, :amount
    add_column :invoices, :amount_cents, :integer
    rename_column :invoices, :hourly_rate, :hourly_rate_cents

    # Since the model is changed in this migration, must reset
    Invoice.reset_column_information
    Invoice.find_each do |invoice|
      invoice.hourly_rate_cents *= 100
      invoice.amount_cents = invoice.hourly_rate_cents * invoice.hours
      invoice.subject ||= 'N/A'
      invoice.tutor_pay_cents ||= invoice.hours * invoice.tutor.contract.hourly_rate.cents
      STDOUT.puts "Updating hourly rate cents to #{invoice.hourly_rate_cents} and amount cents to #{invoice.amount_cents} for invoice ##{invoice.id}"
      STDOUT.puts invoice.save ? 'Success' : 'Failed'
    end
  end

  def down
    remove_column :invoices, :amount_cents
    add_column :invoices, :amount, :decimal, precision: 10, scale: 2
    rename_column :invoices, :hourly_rate_cents, :hourly_rate

    # This will not work if hourly_rate and amount is monetized for Invoices.
    # Comment out that line, or do not rollback
    Invoice.reset_column_information
    Invoice.find_each do |invoice|
      invoice.hourly_rate /= 100
      invoice.amount = invoice.hourly_rate * invoice.hours
      STDOUT.puts "Reverting hourly rate to #{invoice.hourly_rate} and amount to #{invoice.amount} for invoice ##{invoice.id}"
      STDOUT.puts invoice.save ? 'Success' : 'Failed'
    end
  end
end
