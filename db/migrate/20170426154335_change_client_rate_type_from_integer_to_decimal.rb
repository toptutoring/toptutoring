class ChangeClientRateTypeFromIntegerToDecimal < ActiveRecord::Migration[5.0]
  def change
    change_column :users, :academic_rate, :decimal, precision: 10, scale: 2, default: "20.0"
    change_column :users, :test_prep_rate, :decimal, precision: 10, scale: 2, default: "20.0"
  end
end
