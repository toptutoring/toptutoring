class InvoiceHoursChangeColumnType < ActiveRecord::Migration[5.0]
  def up
    change_table :invoices do |t|
      t.change :hours, :decimal, precision: 10, scale: 2, default: 0, null: false
    end
  end
  def down
    change_table :invoices do |t|
      t.change :hours, :integer
    end
  end
end
