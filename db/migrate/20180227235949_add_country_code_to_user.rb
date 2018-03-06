class AddCountryCodeToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :country_code, :string, default: "US"
  end
end
