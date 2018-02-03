class AddAdditionalRatesToClients < ActiveRecord::Migration[5.1]
  def change
    rename_column :users, :academic_rate_cents, :online_academic_rate_cents
    rename_column :users, :academic_rate_currency, :online_academic_rate_currency
    rename_column :users, :test_prep_rate_cents, :online_test_prep_rate_cents
    rename_column :users, :test_prep_rate_currency, :online_test_prep_rate_currency
    add_monetize :users, :in_person_academic_rate
    add_monetize :users, :in_person_test_prep_rate

    rename_column :users, :academic_credit, :online_academic_credit
    rename_column :users, :test_prep_credit, :online_test_prep_credit
    add_column :users, :in_person_academic_credit, :decimal, precision: 10, scale: 2, default: 0.0, null: false
    add_column :users, :in_person_test_prep_credit, :decimal, precision: 10, scale: 2, default: 0.0, null: false
  end
end
