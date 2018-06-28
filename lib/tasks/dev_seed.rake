namespace :dev do
  task seed: :environment do
    # Create Subjects
    Subject.where(name: "Other - If you do not see your subject", category: "other").first_or_create!
    Subject.where(name: "Biology", category: "science").first_or_create!
    Subject.where(name: "Algebra", category: "math").first_or_create!
    Subject.where(name: "English Literature", category: "english").first_or_create!
    Subject.where(name: "SAT", academic_type: "test_prep", category: "test_preparation").first_or_create!
    Subject.where(name: "ACT", academic_type: "test_prep", category: "test_preparation").first_or_create!

    # Update client
    client = User.where(email: "client@example.com").first_or_initialize
    client.first_name = "Client"
    client.last_name = "LastName"
    client.password = "password"
    client.phone_number = "5105555555"
    client.access_state = "enabled"
    client.roles = Role.where(name: "client")
    client.save!
    client.create_client_account!

    #Update signup
    signup = Signup.where(user_id: client.id).first_or_initialize
    signup.subject = Subject.last
    signup.student = false
    signup.save!

    # New client
    client_new = User.where(email: "clientnew@example.com").first_or_initialize
    client_new.first_name = "ClientNew"
    client_new.last_name = "LastName"
    client_new.password = "password"
    client_new.phone_number = "4085555555"
    client_new.access_state = "enabled"
    client_new.roles = Role.where(name: "client")
    client_new.save!
    client_new.create_client_account!

    #Update signup2
    signup2 = Signup.where(user_id: client_new.id).first_or_initialize
    signup2.subject = Subject.last
    signup2.student = false
    signup2.save!

    #Set the client default information for existing clients
    User.clients.each do |client|
      client.update(online_academic_rate_cents: 29_99,
                    online_test_prep_rate_cents: 59_99,
                    in_person_academic_rate_cents: 59_99,
                    in_person_test_prep_rate_cents: 69_99)
    end
    client.reload
    client_new.reload

    # Update student
    student1 = User.where(email: "student1@example.com").first_or_initialize
    student1.first_name = "Student1"
    student1.last_name = "LastName"
    student1.email = "student1@example.com"
    student1.password = "password"
    student1.phone_number = "5105555555"
    student1.access_state = "enabled"
    student1.roles = Role.where(name: "student")
    student1.client_id = client.id
    student1.save!
    student1.create_student_account!(client_account: client.client_account, name: student1.full_name)

    # Update student
    student2 = User.where(email: "student2@example.com").first_or_initialize
    student2.first_name = "Student2"
    student2.last_name = "LastName"
    student2.email = "student2@example.com"
    student2.password = "password"
    student2.phone_number = "5105555555"
    student2.access_state = "enabled"
    student2.roles = Role.where(name: "student")
    student2.client_id = client.id
    student2.save!
    student2.create_student_account!(client_account: client.client_account, name: student2.full_name)

    # Update tutor
    tutor = User.where(email: "tutor@example.com").first_or_initialize
    tutor.first_name = "Tutor"
    tutor.last_name = "LastName"
    tutor.password = "password"
    tutor.phone_number = "5105555555"
    tutor.auth_provider = "dwolla"
    tutor.auth_uid = "854f5ac8-e728-4959-b6e0-13917cd2cf60"
    tutor.token_expires_at = Time.current.to_i + 12.months.to_i
    tutor.access_state = "enabled"
    tutor.roles = Role.where(name: "tutor")
    tutor.create_tutor_account!(online_rate: 40, in_person_rate: 50)
    tutor.save!

    # Update director
    director = User.where(email: "director@example.com").first_or_initialize
    director.first_name = "Director"
    director.last_name = "LastName"
    director.password = "password"
    director.phone_number = "5105555555"
    director.auth_provider = "dwolla"
    director.auth_uid = "eef71d60-c133-4eed-af14-77dd2e4b9950"
    director.token_expires_at = Time.current.to_i + 12.months.to_i
    director.access_state = "enabled"
    director.roles = Role.where(name: ["tutor", "director"])
    director.create_tutor_account!(online_rate: 39, in_person_rate: 50)
    director.save!

    # Update admin
    admin = User.where(email: "admin@example.com").first_or_initialize
    admin.first_name = "Admin"
    admin.last_name = "LastName"
    admin.password = "password"
    admin.phone_number = "5105555555"
    admin.auth_provider = "dwolla"
    admin.auth_uid = ENV.fetch("DWOLLA_DEV_ADMIN_AUTH_UID")
    admin.token_expires_at = Time.current.to_i + 12.months.to_i
    admin.access_state = "enabled"
    admin.roles = Role.where(name: "admin")
    admin.save!

    # Create contractor
    contractor = User.where(email: "contractor@example.com").first_or_initialize
    contractor.first_name = "Contractor"
    contractor.last_name = "LastName"
    contractor.password = "password"
    contractor.phone_number = "5105555555"
    contractor.auth_provider = "dwolla"
    contractor.auth_uid = ENV.fetch("DWOLLA_DEV_ADMIN_AUTH_UID")
    contractor.token_expires_at = Time.current.to_i + 12.months.to_i
    contractor.access_state = "enabled"
    contractor.roles << Role.where(name: "contractor")
    contractor.save!
    contractor.create_contractor_account!(hourly_rate: 15)

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
    Payment.where(payer_id: client.id).destroy_all
    Payment.where(payer_id: admin.id).destroy_all
    Payment.where(payer_id: director.id).destroy_all
    Payment.create(
      amount_cents: 200_00,
      description: "Payment for Tutor",
      status: "succeeded",
      payer_id: client.id,
      stripe_charge_id: "ch_42424242",
      stripe_source: "tok_42424242",
      stripe_account: client.stripe_account
    )
  end
end
