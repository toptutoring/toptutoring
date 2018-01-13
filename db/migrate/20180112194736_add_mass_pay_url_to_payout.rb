class AddMassPayUrlToPayout < ActiveRecord::Migration[5.1]
  def change
    add_column :payouts, :dwolla_mass_pay_url, :string
    add_column :payouts, :dwolla_mass_pay_item_url, :string
  end
end
