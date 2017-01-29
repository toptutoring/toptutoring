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
    tutor.encrypted_access_token = "Faya+QFTAqDK/HejVyFSQE7NXeJ62Wq17X8fi8yXrGa7D7Gpmllae3pwHZWU\nvi8vwa/QLboKPyujrBtiRxdNKDiP\n"
    tutor.encrypted_access_token_iv = "sRcxsHGPXga/Km3/\n"
    tutor.encrypted_refresh_token = "vCHS6EBaZQBOXY7auilqkNjARPOxkIbUxFAnDR1fstYLh7rWL7LqeN6q9PXK\nuTaewrvlc0qGbFNo36Xo9zIkSDPm\n"
    tutor.encrypted_refresh_token_iv = "kZ9NcFa83Luy9D/w\n"
    tutor.token_expires_at = 1485632484
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
    director.encrypted_access_token = "Rz3gKQ5w5hrsG+9nMvRp8QfoK/eVkKpLgWL3jYyZpZFxjAnRsKJ899970ya2\n9STIHdYAw4Hx3J4PzxbrnNhzB/P4\n"
    director.encrypted_access_token_iv = "d1RRn/INxRanwxGw\n"
    director.encrypted_refresh_token = "5uwGXsQq8joBWnsOAdoUOoFluGESpufWsdyOZ/wcqxRIf0MiuqVCMgnt95ii\nIFtgM4cUZVJo3/34oX7wdhNYXqIv\n"
    director.encrypted_refresh_token_iv = "aQ6qrr0TIBX+FtMy\n"
    director.token_expires_at = 1485692493
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
    admin.encrypted_access_token = "FnNmzQI7e/JQsuJ5td9YaPY9OX60ywdN6qDkAqQlJsW4ccxOR/PM7v6kJfYN\nKAkrxSh1Ftc3XIxT4QPAf7AP/r4y\n"
    admin.encrypted_access_token_iv = "xoYoqMFjId8buxXC\n"
    admin.encrypted_refresh_token = "AcjtbFNP/P0uKIEmiddNf1jMuoZLbWlcimgKlELeYo2VhQMaTdDGmYtJ3uSM\n4vrZMLQuWSK/cIQV7zps/jqAfDv5\n"
    admin.encrypted_refresh_token_iv = "yFGB+KiSDcIyKLzF\n"
    admin.token_expires_at = 1485692309
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
