class City < ApplicationRecord
  before_validation :add_slug, if: :name_changed?
  belongs_to :country

  validates :phone_number, phone: { possible: true, country_specifier: -> city { city.country.code } }
  validates_presence_of :name, :description, :country_id, :phone_number
  validates :slug, uniqueness: true

  def add_slug
    url = state ? "#{name}-#{state}" : name
    self.slug = url.downcase.tr(' ', '-').concat('-tutoring')
  end
end
