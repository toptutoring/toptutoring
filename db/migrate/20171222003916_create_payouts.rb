class CreatePayouts < ActiveRecord::Migration[5.1]
  def change
    create_table :payouts do |t|
      t.string :description
      t.string :destination
      t.string :dwolla_transfer_url
      t.string :status
      t.string :funding_source
      t.monetize :amount
      t.integer :approver_id
      t.references :receiving_account, polymorphic: true, index: false
      t.index [:receiving_account_id, :receiving_account_type], name: "index_payouts_receiver_account_and_type"
      t.timestamps
    end
  end
end
