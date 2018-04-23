class City < ApplicationRecord
  before_validation :add_slug, if: :name_changed?
  belongs_to :country

  validates :phone_number, phone: { possible: true, country_specifier: -> city { city.country.code } }
  validates_presence_of :name, :description, :country_id, :phone_number, :state, :zip, :address
  validates :slug, uniqueness: true

  mount_uploader :picture, CityPictureUploader

  def add_slug
    url = state ? "#{name}-#{state}" : name
    self.slug = url.downcase.tr(' ', '-').concat('-tutoring')
  end

  def country_code
    country.code
  end

  def name_state_zip
    "#{name}, #{state.upcase} #{zip}"
  end
end
