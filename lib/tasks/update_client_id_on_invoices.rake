namespace :update do
  task :correct_client_id_on_invoices => :environment do
    updating_invoices = Invoice.where(client_id: nil)
    total_invoices = updating_invoices.count

    if updating_invoices.empty?
      STDOUT.puts "There were no invoices to change."
    else
      updating_invoices.find_each do |invoice| 
        invoice.client_id = invoice.engagement.client_id
        STDOUT.puts "Updating Invoice ##{invoice.id} with client id of #{invoice.client_id}"
        STDOUT.puts invoice.save ? "Successful" : "Failed"
      end

      STDOUT.puts "Total Invoices updated: #{total_invoices}"
    end
  end
end
