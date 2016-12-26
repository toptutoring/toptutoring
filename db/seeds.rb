# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

tutor = User.create!(email: "tutor@example.com", password: 'password', name: 'tutor').create_tutor(subject: "Math", activity_type: "VAT")
parent = User.create(email: "parent@example.com", password: 'password', name: 'parent')
student = parent.create_student(email: "student@example.com", name: 'student', subject: "Math", activity_type: "SAT")
