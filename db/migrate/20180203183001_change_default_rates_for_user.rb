class ChangeDefaultRatesForUser < ActiveRecord::Migration[5.1]
  def change
    change_column_default :users, :online_academic_rate_cents, 0
    change_column_default :users, :online_test_prep_rate_cents, 0
  end
end
