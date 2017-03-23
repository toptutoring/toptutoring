namespace :prod do
  task seed: :environment do
    # Update client
    client = User.where(email: "client@example.com").first_or_initialize
    client.name = "Client"
    client.password = "password"
    client.customer_id = "cus_A45BGhlr4VjDcJ"
    client.access_state = "enabled"
    client.demo = true
    client.roles = "client"
    client.save!

    # Update student
    student = User.where(client_id: client.id).first_or_initialize
    student.name = "Student"
    student.password = "password"
    student.email = "student@example.com"
    client.access_state = "enabled"
    client.demo = true
    student.roles = "student"
    student.save!

    # Update student info
    student_info = StudentInfo.where(user_id: student.id).first_or_initialize
    student_info.subject = "Math"
    student_info.academic_type = "Test Prep"
    student_info.save!

    # Update tutor
    tutor = User.where(email: "tutor@example.com").first_or_initialize
    tutor.name = "Tutor"
    tutor.password = "password"
    tutor.auth_provider = "dwolla"
    tutor.access_state = "enabled"
    tutor.balance = 2
    tutor.demo = true
    tutor.roles = "tutor"
    tutor.save!

    tutor_info = TutorInfo.where(user_id: tutor.id).first_or_initialize
    tutor_info.subject = "Math"
    tutor_info.academic_type = "Test Prep"
    tutor_info.hourly_rate = 20
    tutor_info.save!

    # Update director
    director = User.where(email: "director@example.com").first_or_initialize
    director.name = "Director"
    director.password = "password"
    director.auth_provider = "dwolla"
    director.access_state = "enabled"
    director.balance = 2
    director.demo = true
    director.roles = ["tutor", "director"]
    director.save!

    director_info = TutorInfo.where(user_id: director.id).first_or_initialize
    director_info.subject = "Math"
    director_info.academic_type = "Test Prep"
    director_info.director = true
    director_info.hourly_rate = 20
    director_info.save!

    # Update admin
    admin = User.where(email: "admin@example.com").first_or_initialize
    admin.name = "Admin"
    admin.password = "adminpassword123"
    admin.admin = true
    admin.auth_provider = "dwolla"
    admin.access_state = "enabled"
    admin.demo = true
    admin.roles = "admin"
    admin.save!

    # Update assignments
    tutor.assignments.destroy_all
    assignment = Assignment.create(
      tutor_id: tutor.id,
      student_id: student.id,
      subject: student.student_info.subject,
      academic_type: student.student_info.academic_type,
      hourly_rate: 20
    )
    assignment.enable!

    # Delete test payments
    Payment.from_customer(client.customer_id).destroy_all
    Payment.where(payer_id: admin.id).destroy_all
    Payment.where(payer_id: director.id).destroy_all
  end
end
