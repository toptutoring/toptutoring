namespace :dev do
  task seed: :environment do
    # Create Subjects
    Subject.where(name: "Biology").first_or_create!
    Subject.where(name: "Algebra").first_or_create!
    Subject.where(name: "English_Literature").first_or_create!

    # Update client
    client = User.where(email: "client@example.com").first_or_initialize
    client.name = "Client"
    client.password = "password"
    client.customer_id = "cus_A45BGhlr4VjDcJ"
    client.access_state = "enabled"
    client.roles = Role.where(name: "client")
    client.save!
    client.create_client_account!

    # New client
    client_new = User.where(email: "clientnew@example.com").first_or_initialize
    client_new.name = "Client"
    client_new.password = "password"
    client_new.customer_id = nil
    client_new.access_state = "enabled"
    client_new.roles = Role.where(name: "client")
    client_new.save!
    client_new.create_client_account!

    #Update signup
    signup = Signup.where(user_id: client.id).first_or_initialize
    signup.subject = Subject.last
    signup.student = false
    signup.save!

    # Update student
    student1 = User.where(email: "student1@example.com").first_or_initialize
    student1.name = "Student1"
    student1.email = "student1@example.com"
    student1.password = "password"
    student1.access_state = "enabled"
    student1.roles = Role.where(name: "student")
    student1.client_id = client.id
    student1.save!
    student1.create_student_account!(client_account: client.client_account, name: student1.name)

    # Update student
    student2 = User.where(email: "student2@example.com").first_or_initialize
    student2.name = "Student2"
    student2.email = "student2@example.com"
    student2.password = "password"
    student2.access_state = "enabled"
    student2.roles = Role.where(name: "student")
    student2.client_id = client.id
    student2.save!
    student2.create_student_account!(client_account: client.client_account, name: student2.name)

    # Update tutor
    tutor = User.where(email: "tutor@example.com").first_or_initialize
    tutor.name = "Tutor"
    tutor.password = "password"
    tutor.auth_provider = "dwolla"
    tutor.auth_uid = "854f5ac8-e728-4959-b6e0-13917cd2cf60"
    tutor.token_expires_at = Time.current.to_i + 12.months.to_i
    tutor.access_state = "enabled"
    tutor.roles = Role.where(name: "tutor")
    tutor.create_tutor_account!
    tutor.save!

    contract = Contract.where(tutor_account_id: tutor.tutor_account.id).first_or_initialize
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
    director.roles = Role.where(name: ["tutor", "director"])
    director.create_tutor_account!
    director.save!

    contract = Contract.where(tutor_account_id: director.tutor_account.id).first_or_initialize
    contract.hourly_rate = 40
    contract.save!

    # Update admin
    admin = User.where(email: "admin@example.com").first_or_initialize
    admin.name = "Admin"
    admin.password = "password"
    admin.auth_provider = "dwolla"
    admin.auth_uid = ENV.fetch("DWOLLA_DEV_ADMIN_AUTH_UID")
    admin.token_expires_at = Time.current.to_i + 12.months.to_i
    admin.access_state = "enabled"
    admin.roles = Role.where(name: "admin")
    admin.save!

    # Create contractor
    contractor = User.where(email: "contractor@example.com").first_or_initialize
    contractor.name = "Contractor"
    contractor.password = "password"
    contractor.auth_provider = "dwolla"
    contractor.auth_uid = ENV.fetch("DWOLLA_DEV_ADMIN_AUTH_UID")
    contractor.token_expires_at = Time.current.to_i + 12.months.to_i
    contractor.access_state = "enabled"
    contractor.roles << Role.where(name: "contractor")
    contractor.roles << Role.where(name: "tutor")
    contractor.save!
    contractor.create_tutor_account!.create_contract!

    # Update engagements
    tutor.tutor_account.engagements.destroy_all
    engagement = Engagement.create!(
      tutor_account: tutor.tutor_account,
      student_account: student1.student_account,
      client_account: client.client_account,
      subject: client.signup.subject
    )
    engagement.enable!

    engagement = Engagement.create!(
      tutor_account: tutor.tutor_account,
      student_account: student2.student_account,
      client_account: client.client_account,
      subject: client.signup.subject
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
