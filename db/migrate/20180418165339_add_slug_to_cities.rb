class AddSlugToCities < ActiveRecord::Migration[5.1]
  def change
    add_column :cities, :slug, :string
    add_index :cities, :slug, unique: true
    create_slugs_for_all_users
  end

  def create_slugs_for_all_users
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
end
