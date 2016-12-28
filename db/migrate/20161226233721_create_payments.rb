class CreatePayments < ActiveRecord::Migration[5.0]
  def change
    create_table :payments do |t|
      t.integer :amount
      t.string :description
      t.string :status
      t.string :source
      t.string :destination
      t.string :external_code
      t.string :customer_id
      t.references :payer, index: true
      t.references :payee, index: true
    end

    add_foreign_key :payments, :users, column: :payer_id
    add_foreign_key :payments, :users, column: :payee_id
  end
end
