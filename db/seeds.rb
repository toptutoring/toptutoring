# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Create users
# Users have the password "Passw0rd" in dwolla sandbox.
# Admin has email "admin@tutoring.com" in dwolla sandbox.
tutor = User.create!(name: "Tutor", email: "tutor@toptutoring.com", password: "password").create_tutor(subject: "Math", activity_type: "VAT")
director = User.create!(name: "Director", email: "director@toptutoring.com", password: "password").create_tutor(subject: "Math", activity_type: "VAT", director: true)
parent = User.create(name: "Parent", email: "parent@toptutoring.com", password: "password")
student = parent.create_student(name: "Student", email: "student@toptutoring.com", subject: "Math", activity_type: "SAT")
admin = User.create!(name: "Admin", email: "admin@toptutoring.com", password: "adminpassword123", admin: "true")
