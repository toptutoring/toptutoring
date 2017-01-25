class AddDateToPayments < ActiveRecord::Migration[5.0]
  def change
    add_column :payments, :created_at, :datetime
  end
end
