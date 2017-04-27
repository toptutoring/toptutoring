namespace :create do
  task subjects: :environment do
    require 'csv'

    file = File.expand_path('../subjects.csv', __FILE__)
    CSV.foreach(file, :headers => true) do |row|
      Subject.create!(row.to_hash)
    end
  end
end
