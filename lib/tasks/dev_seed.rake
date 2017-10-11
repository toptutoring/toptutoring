namespace :dev do
  task seed: :environment do
    # Update client
    client = User.where(email: "client@example.com").first_or_initialize
    client.name = "Client"
    client.password = "password"
    client.customer_id = "cus_A45BGhlr4VjDcJ"
    client.access_state = "enabled"
    client.roles = "client"
    client.save!

      # New client
    client_new = User.where(email: "clientnew@example.com").first_or_initialize
    client_new.name = "Client"
    client_new.password = "password"
    client_new.customer_id = ""
    client_new.access_state = "enabled"
    client_new.roles = "client"
    client_new.save!

    #Update signup
    signup = Signup.where(user_id: client.id).first_or_initialize
    signup.subject = "SAT"
    signup.student = false
    signup.save!

     # Update student
    student1 = User.where(email: "student1@example.com").first_or_initialize
    student1.name = "Student1"
    student1.email = "student1@example.com"
    student1.password = "password"
    student1.access_state = "enabled"
    student1.roles = "student"
    student1.client_id = client.id
    student1.save!

     # Update student
    student2 = User.where(email: "student2@example.com").first_or_initialize
    student2.name = "Student2"
    student2.email = "student2@example.com"
    student2.password = "password"
    student2.access_state = "enabled"
    student2.roles = "student"
    student2.client_id = client.id
    student2.save!

    # Update tutor
    tutor = User.where(email: "tutor@example.com").first_or_initialize
    tutor.name = "Tutor"
    tutor.password = "password"
    tutor.auth_provider = "dwolla"
    tutor.auth_uid = "854f5ac8-e728-4959-b6e0-13917cd2cf60"
    tutor.token_expires_at = Time.current.to_i + 12.months.to_i
    tutor.access_state = "enabled"
    tutor.roles = ["tutor"]
    tutor.save!

    contract = Contract.where(user_id: tutor.id).first_or_initialize
    contract.hourly_rate = 40
    contract.save!

    # Update director
    director = User.where(email: "director@example.com").first_or_initialize
    director.name = "Director"
    director.password = "password"
    director.auth_provider = "dwolla"
    director.auth_uid = "eef71d60-c133-4eed-af14-77dd2e4b9950"
    director.token_expires_at = Time.current.to_i + 12.months.to_i
    director.access_state = "enabled"
    director.roles = ["tutor", "director"]
    director.save!

    contract = Contract.where(user_id: director.id).first_or_initialize
    contract.hourly_rate = 40
    contract.save!

    # Update admin
    admin = User.where(email: "admin@example.com").first_or_initialize
    admin.name = "Admin"
    admin.password = "password"
    admin.auth_provider = "dwolla"
    admin.auth_uid = ENV.fetch('DWOLLA_DEV_ADMIN_AUTH_UID')
    admin.token_expires_at = Time.current.to_i + 12.months.to_i
    admin.access_state = "enabled"
    admin.roles = "admin"
    admin.save!

    # Update engagements
    tutor.tutor_engagements.destroy_all
    engagement = Engagement.create(
      tutor_id: tutor.id,
      student_name: student1.name,
      student_id: student1.id,
      client_id: client.id,
      subject: client.signup.subject,
      academic_type: "Academic"
    )
    engagement.enable!

    engagement = Engagement.create(
      tutor_id: tutor.id,
      student_name: student2.name,
      student_id: student2.id,
      client_id: client.id,
      subject: client.signup.subject,
      academic_type: "Test_Prep"
    )
    engagement.enable!

    # Update invoices
    tutor.invoices.destroy_all

    # Update payments
    Payment.from_user(client.id).destroy_all
    Payment.where(payer_id: admin.id).destroy_all
    Payment.where(payer_id: director.id).destroy_all
    Payment.create(
      amount_cents: 200_00,
      description: "Payment for Tutor",
      status: "succeeded",
      customer_id: client.customer_id,
      payer_id: client.id,
      payee_id: tutor.id)
    #Set the client default information for existing clients
    User.clients.each do |client|
      client.academic_rate_cents = 2999
      client.test_prep_rate_cents = 5999
      client.academic_credit = 0.0
      client.test_prep_credit = 0.0
      client.save
    end
  end
end
