class UpdateSessionDatesForInvoices < ActiveRecord::Migration[5.1]
  def change
    Invoice.find_each do |invoice|
      next unless invoice.by_tutor? && invoice.session_date.nil?
      invoice.session_date = invoice.created_at
      if invoice.save
        STDOUT.puts "Updated invoice ##{invoice.id}'s session_date to #{invoice.session_date}."
      else
        STDOUT.puts "Unable to update session date for invoice ##{invoice.id}."
      end
    end
  end
end
