namespace :dev do
  task seed: :environment do
    # Update parent
    parent = User.where(email: "parent@example.com").first_or_initialize
    parent.name = "Parent"
    parent.password = "password"
    parent.customer_id = "cus_A45BGhlr4VjDcJ"
    parent.access_state = "enabled"
    parent.demo = true
    parent.save!

    # Update student
    student = Student.where(user_id: parent.id).first_or_initialize
    student.name = "Student"
    student.email = "student@example.com"
    student.subject = "Math"
    student.academic_type = "Test Prep"
    student.save!

    # Update tutor
    tutor = User.where(email: "tutor@example.com").first_or_initialize
    tutor.name = "Tutor"
    tutor.password = "password"
    tutor.auth_provider = "dwolla"
    tutor.auth_uid = "854f5ac8-e728-4959-b6e0-13917cd2cf60"
    tutor.token_expires_at = Time.current.to_i + 12.months.to_i
    tutor.access_state = "enabled"
    tutor.balance = 2
    tutor.demo = true
    tutor.save!

    tutor_info = Tutor.where(user_id: tutor.id).first_or_initialize
    tutor_info.subject = "Math"
    tutor_info.academic_type = "Test Prep"
    tutor_info.hourly_rate = 20
    tutor_info.save!

    # Update director
    director = User.where(email: "director@example.com").first_or_initialize
    director.name = "Director"
    director.password = "password"
    director.auth_provider = "dwolla"
    director.auth_uid = "eef71d60-c133-4eed-af14-77dd2e4b9950"
    director.token_expires_at = Time.current.to_i + 12.months.to_i
    director.access_state = "enabled"
    director.balance = 2
    director.demo = true
    director.save!

    director_info = Tutor.where(user_id: director.id).first_or_initialize
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
    admin.auth_uid = "8fb759cf-b90d-4ac8-b00e-9760bbfa1a7f"
    admin.token_expires_at = Time.current.to_i + 12.months.to_i
    admin.access_state = "enabled"
    admin.demo = true
    admin.save!

    # Update assignments
    tutor.assignments.destroy_all
    assignment = Assignment.create(
      tutor_id: tutor.id,
      student_id: parent.id,
      subject: student.subject,
      academic_type: student.academic_type,
      hourly_rate: 30
    )
    assignment.enable!

    # Update payments
    Payment.from_customer(parent.customer_id).destroy_all
    Payment.where(payer_id: admin.id).destroy_all
    Payment.where(payer_id: director.id).destroy_all
    Payment.create(
      amount: 200,
      description: "Payment for Tutor",
      status: "succeeded",
      customer_id: parent.customer_id,
      payer_id: parent.id,
      payee_id: tutor.id)
  end
end
