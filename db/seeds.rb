# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Create roles
Role.where(name: "admin").first_or_create
Role.where(name: "director").first_or_create
Role.where(name: "tutor").first_or_create
Role.where(name: "client").first_or_create
Role.where(name: "student").first_or_create
Role.where(name: "contractor").first_or_create

if Rails.env.test?
  FactoryBot.create(:admin_user) 
end

# Run seeds for development environment
Rake::Task['dev:seed'].invoke if Rails.env.development? || Rails.env.staging?
