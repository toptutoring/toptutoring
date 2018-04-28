class RemoveCountryFromCities < ActiveRecord::Migration[5.1]
  def change
    remove_column :cities, :country
  end
end
