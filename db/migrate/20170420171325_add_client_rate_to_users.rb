class AddClientRateToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :academic_rate, :integer, :default => 20
    add_column :users, :test_prep_rate, :integer, :default => 20
  end
end
