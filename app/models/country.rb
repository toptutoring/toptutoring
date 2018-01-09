class Country < ApplicationRecord
  has_many :cities

  enum region: { north_america: "north_america",
                 asia: "asia" }

  def self.regions_as_options
    regions.map { |name, value| [name.titlecase, value] }
  end
end
