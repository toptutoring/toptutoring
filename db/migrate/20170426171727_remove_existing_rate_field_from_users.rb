class RemoveExistingRateFieldFromUsers < ActiveRecord::Migration[5.0]
  def change
    remove_column :users, :academic_rate
    remove_column :users, :test_prep_rate
  end
end
