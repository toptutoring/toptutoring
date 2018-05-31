class CreateRefunds < ActiveRecord::Migration[5.1]
  def change
    create_table :refunds do |t|
      t.string :stripe_refund_id
      t.references :payment, foreign_key: true
      t.monetize :amount
      t.decimal :hours, precision: 10, scale: 2, default: "0.0", null: false
      t.text :reason

      t.timestamps
    end
  end
end
