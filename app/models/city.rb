class City < ApplicationRecord
  before_validation :add_slug
  belongs_to :country

  validates :phone_number, phone: { possible: true, country_specifier: -> city { city.country.code } }
  validates_presence_of :name, :description, :country_id, :phone_number
  validates :slug, uniqueness: true

  def add_slug
    self.slug = name.downcase.tr(' ', '-').concat('-tutoring')
  end
end
