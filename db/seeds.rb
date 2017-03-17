# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
# Create roles
Role.create(name: "admin")
Role.create(name: "director")
Role.create(name: "tutor")
Role.create(name: "client")
Role.create(name: "student")

# Create users
# Users have the password "Passw0rd" in dwolla sandbox.
# Admin has email "admin@tutoring.com" in dwolla sandbox.
# Director has email "director@toptutor.com" in dowlla sandbox.
tutor = User.create!(name: "Tutor", email: "tutor@example.com", password: "password", roles: "tutor")
tutor_info = tutor.create_tutor_info(subject: "Math", academic_type: "Test Prep", hourly_rate: 20)
director = User.create!(name: "Director", email: "director@example.com", password: "password", roles: ["tutor", "director"]).create_tutor_info(subject: "Math", academic_type: "Test Prep")
client = User.create(name: "Client", email: "client@example.com", password: "password", roles: "client")
student = User.create(name: "Student", email: "student@example.com", password: "password", roles: "student", client_id: client.id)
student_info = student.create_student_info(subject: "Math", academic_type: "Test Prep")
assignment = Assignment.create(tutor_id: tutor.id, student_id: student.id, subject: student.student_info.subject, academic_type: student.student_info.academic_type, hourly_rate: 30)
assignment.enable!
admin = User.create!(name: "Admin", email: "admin@example.com", password: "adminpassword123", roles: "admin")

# Run the prod seed update task to update values
Rake::Task['prod:seed'].invoke
