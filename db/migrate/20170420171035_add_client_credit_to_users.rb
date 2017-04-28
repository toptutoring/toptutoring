class AddClientCreditToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :academic_credit, :decimal, precision: 10, scale: 2, default: "0.0", null: false
    add_column :users, :test_prep_credit, :decimal, precision: 10, scale: 2, default: "0.0", null: false
  end
end
