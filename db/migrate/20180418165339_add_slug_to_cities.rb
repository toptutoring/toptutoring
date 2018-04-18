class AddSlugToCities < ActiveRecord::Migration[5.1]
  class City < ApplicationRecord
    before_validation :add_slug
    belongs_to :country

    validates :phone_number, phone: { possible: true, country_specifier: -> city { city.country.code } }
    validates_presence_of :name, :description, :country_id, :phone_number
    validates :slug, uniqueness: true

    def add_slug
      if state
        self.slug = "#{name}-#{state}".downcase.tr(' ', '-').concat('-tutoring')
      else
        self.slug = name.downcase.tr(' ', '-').concat('-tutoring')
      end
    end
  end

  def up
    add_column :cities, :slug, :string
    add_index :cities, :slug, unique: true
    create_slugs_for_all_cities
  end

  def down
    remove_slugs_for_all_cities
    remove_index :cities, :slug
    remove_column :cities, :slug
  end

  private

  def create_slugs_for_all_cities
    City.reset_column_information
    City.all.find_each do |city|
      city.add_slug
      if city.save
        STDOUT.puts "Added slug #{city.slug} for city ##{city.id}"
      else
        STDOUT.puts "Unable to add a slug for city ##{city.id}"
      end
    end
  end

  def remove_slugs_for_all_cities
    City.reset_column_information
    City.all.find_each do |city|
      city.slug = nil
      if city.save
        STDOUT.puts "Removed slug for city ##{city.id}"
      else
        STDOUT.puts "Unable to remove slug for city ##{city.id}"
      end
    end
  end
end
