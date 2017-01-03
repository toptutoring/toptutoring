namespace :prod do
  task seed: :environment do
    # Update parent
    parent = User.where(email: "parent@toptutoring.com").first_or_initialize
    parent.name = "Parent"
    parent.password = "password"
    parent.customer_id = "cus_9pLqJitvVtlSXr"
    parent.save!
    parent.enable!

    # Update student
    student = Student.where(user_id: parent.id).first_or_initialize
    student.name = "Student",
    student.email = "student@toptutoring.com",
    student.subject = "Math",
    student.academic_type = "Test Prep"
    student.save!

    # Update tutor
    tutor = User.where(email: "tutor@toptutoring.com").first_or_initialize
    tutor.name = "Tutor"
    tutor.password = "password"
    tutor.auth_provider = "dwolla"
    tutor.auth_uid = "854f5ac8-e728-4959-b6e0-13917cd2cf60"
    tutor.encrypted_access_token = "0A5jAEX8D9UqV/0/ZiUWd3Q/wBlTaV64JtWHqYcntH0Ch2iaVuU0a+EjT+Y1\nrHvk6eA2I5vWWbvV3WSDuCqXDrRO\n"
    tutor.encrypted_access_token_iv = "BuiS/0btfFFtyo2C\n"
    tutor.encrypted_refresh_token = "syJw0E8cFDEqBHsOBVJXnomByFwn7NxUDEilZAuxwTnaMU6kokI5YsAmIj4r\nTWIpWpw8g72E3+16D53tAHMGFLFQ\n"
    tutor.encrypted_refresh_token_iv = "3mWniaKYXeuCbh6/\n"
    tutor.token_expires_at = 1482931110
    tutor.save!
    tutor.enable!

    tutor_info = Tutor.where(user_id: tutor.id).first_or_initialize
    tutor_info.subject = "Math"
    tutor_info.academic_type = "Test Prep"
    tutor_info.save!

    # Update director
    director = User.where(email: "director@toptutoring.com").first_or_initialize
    director.name = "Director"
    director.password = "password"
    director.save!
    director.enable!

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
    admin.encrypted_access_token = "mFkL+ribc3QgrgawJEhcf50mkwOXE0xwm69OEpwak8bMqWfLEkB8/TbReKrU\nkT+Jb6c2GbhAgRhKQUejJ2Z5DOeC\n"
    admin.encrypted_access_token_iv = "c9p0rnaMMViAnzVm\n"
    admin.encrypted_refresh_token = "ftHidcBP/NfGtBUlxBWTbsAdwMc7NqHLPjXwJyDcT0z/zeOHMqtd1ktLs/2u\nSEypEJklv+I8rUmhtXicmyZyeRni\n"
    admin.encrypted_refresh_token_iv = "QptZJBCecrjtF1wJ\n"
    admin.token_expires_at = 1482932904
    admin.save!
    admin.enable!

    # Update payments
      parent.payments.destroy
      Payment.create(
        amount: 200,
        description: "Payment for Tutor",
        status: "succeeded",
        customer_id: parent.customer_id,
        payer_id: parent.id,
        payee_id: tutor.id)
  end
end
