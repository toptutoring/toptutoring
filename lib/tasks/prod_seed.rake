namespace :prod do
  task seed: :environment do
    # Update parent
    parent = User.where(email: "parent@toptutoring.com").first_or_initialize
    parent.name = "Parent"
    parent.password = "password"
    parent.customer_id = "cus_9xET9cNmAJjO8A"
    parent.access_state = "enabled"
    parent.save!

    # Update student
    student = Student.where(user_id: parent.id).first_or_initialize
    student.name = "Student"
    student.email = "student@toptutoring.com"
    student.subject = "Math"
    student.academic_type = "Test Prep"
    student.save!

    # Update tutor
    tutor = User.where(email: "tutor@toptutoring.com").first_or_initialize
    tutor.name = "Tutor"
    tutor.password = "password"
    tutor.auth_provider = "dwolla"
    tutor.auth_uid = "854f5ac8-e728-4959-b6e0-13917cd2cf60"
    tutor.encrypted_access_token = "kmUbaKcZv1Ia4/muQCWPqI9iuAshoc5pUT/cuAtYmeuPRzyKddcmAB8IVwBi\nhMh1m9a3DR4H+hF0dcoirEG9Qzo9\n"
    tutor.encrypted_access_token_iv = "JaXjfkqC/SVme9mC\n"
    tutor.encrypted_refresh_token = "99HdtNneryU875PDFp+yULGzo0Bii0GOnu+40k1PNgRwcuHe/tPZ7IGDYxVb\nkY2lIPIjuIKg8NEhCA0k622gxwaH\n"
    tutor.encrypted_refresh_token_iv = "WDhbS1OoyvVxXzHh\n"
    tutor.token_expires_at = 1485294818
    tutor.access_state = "enabled"
    tutor.save!

    tutor_info = Tutor.where(user_id: tutor.id).first_or_initialize
    tutor_info.subject = "Math"
    tutor_info.academic_type = "Test Prep"
    tutor_info.save!

    # Update director
    director = User.where(email: "director@toptutoring.com").first_or_initialize
    director.name = "Director"
    director.password = "password"
    director.access_state = "enabled"
    director.save!

    director_info = Tutor.where(user_id: director.id).first_or_initialize
    director_info.subject = "Math"
    director_info.academic_type = "Test Prep"
    director_info.director = true
    director_info.save!

    # Update admin
    admin = User.where(email: "admin@toptutoring.com").first_or_initialize
    admin.name = "Admin"
    admin.password = "adminpassword123"
    admin.admin = true
    admin.auth_provider = "dwolla"
    admin.auth_uid = "c6afd2f7-0825-4049-8eab-daafd7f84df4"
    admin.encrypted_access_token = "G63QqjhYAp48IW18IayWHlYbmHwXFWGfe5fvdt/nSpuOVw3XY2rQQQS5Dy+C\n5U5g28mmSI1NzHGjCKHBh5QnEsmr\n"
    admin.encrypted_access_token_iv = "G27TdUpzwLdZ67lF\n"
    admin.encrypted_refresh_token = "tXXBSmCUqEDQc/c7G+NQDyuy/v3dwuyGsWG4MrDkkym+df2YMVxHEuXwTYP0\nKTqGpfEg5Mbk1QSGpuq3Rezjl9qA\n"
    admin.encrypted_refresh_token_iv = "zPYh1yAlPQtOr9kq\n"
    admin.token_expires_at = 1485294294
    admin.access_state = "enabled"
    admin.save!

    # Update assignments
    tutor.assignments.destroy_all
    assignment = Assignment.create(
      tutor_id: tutor.id,
      student_id: parent.id,
      subject: student.subject,
      academic_type: student.academic_type,
      hourly_rate: 20
    )
    assignment.enable!

    # Update payments
    Payment.from_customer(parent.customer_id).destroy_all
    Payment.create(
      amount: 200,
      description: "Payment for Tutor",
      status: "succeeded",
      customer_id: parent.customer_id,
      payer_id: parent.id,
      payee_id: tutor.id)
  end
end
