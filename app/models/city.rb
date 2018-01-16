class City < ApplicationRecord
  belongs_to :country

  validates :phone_number, phone: { possible: true, country_specifier: -> city { city.country.code } }
  validates_presence_of :name, :description, :country_id, :phone_number
end
