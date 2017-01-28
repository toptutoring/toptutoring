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
    tutor.balance = 200
    tutor.save!

    tutor_info = Tutor.where(user_id: tutor.id).first_or_initialize
    tutor_info.subject = "Math"
    tutor_info.academic_type = "Test Prep"
    tutor_info.save!

    # Update director
    director = User.where(email: "director@toptutoring.com").first_or_initialize
    director.name = "Director"
    director.password = "password"
    director.auth_provider = "dwolla"
    director.auth_uid = "eef71d60-c133-4eed-af14-77dd2e4b9950"
    director.encrypted_access_token = "+/84IHlVuaJn/x0hu0XGYmwhx9JJBc7QmtTPaYFjl9rREGkG75sLyCNSo583\ngD8QxFanK1U+21FtWBwKv8lH0cPG\n"
    director.encrypted_access_token_iv = "wiYo5eSFYpEVwA0I\n"
    director.encrypted_refresh_token = "JAKIiXuzvMSLRt8frqXrLKEgUYMVxtc7ekhRrFC6nNmW5MrwIrR5Vko619nO\nOXAxmxRzjzErdcLJnhD+ourGUyhh\n"
    director.encrypted_refresh_token_iv = "Evnq72hkmE0TNOuL\n"
    director.token_expires_at = 1485624471
    director.access_state = "enabled"
    director.balance = 200
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
    admin.auth_uid = "8fb759cf-b90d-4ac8-b00e-9760bbfa1a7f"
    admin.encrypted_access_token = "VqnBLMc9Tcm/Rh7/9W2Ri3JZAy5+/ChD2gJ0YHgWyYWcnxzkgqSwxCgVmyH5\nMPsmSOLY+VR3qHsXx9Db1pIFT66a\n"
    admin.encrypted_access_token_iv = "Mmpxw3eGM6TFvFbl\n"
    admin.encrypted_refresh_token = "GAuJyoBXf1H6lK7BGyZZqw0a733YzgVqgw+Jb29cfUT8pn77KbMc/nYGNS68\nouGtVzk37har7vbj795dc9GoNUwZ\n"
    admin.encrypted_refresh_token_iv = "aqDNOlMrFyIwrjqU\n"
    admin.token_expires_at = 1485621339
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
