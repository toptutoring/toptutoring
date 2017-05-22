class AddStudentToInvoice < ActiveRecord::Migration[5.0]
  def change
    add_reference :invoices, :client, index: true
    Invoice.all.each do |invoice|
      invoice.client_id = User.find(invoice.student_id).client.id
      invoice.save!
    end
    remove_column :invoices, :student_id, :integer
  end
end
