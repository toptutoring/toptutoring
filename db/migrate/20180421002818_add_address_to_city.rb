class AddAddressToCity < ActiveRecord::Migration[5.1]
  def change
    add_column :cities, :address, :string
    add_column :cities, :zip, :integer
  end
end
