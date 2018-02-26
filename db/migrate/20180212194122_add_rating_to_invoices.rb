class AddRatingToInvoices < ActiveRecord::Migration[5.1]
  def change
    add_column :invoices, :session_rating, :integer
  end
end
