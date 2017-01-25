class CreateInvoices < ActiveRecord::Migration[5.0]
  def change
    create_table :invoices do |t|
      t.references :student, index: true
      t.references :tutor, index: true
      t.references :assignment, index: true
      t.integer :hours
      t.integer :hourly_rate
      t.integer :amount
      t.string :description
      t.timestamps
    end
  end
end
