require "rails_helper"

feature "Create user as first step of sign up process" do
  let(:admin) { User.admin }
  let!(:subject_academic) { FactoryBot.create(:subject) }

  context "with valid params" do
    scenario "when user is a client that is not a student" do
      admin # creates admin user to check if email is sent to admin
      visit client_sign_up_path

      name = "ClientName"
      last_name = "ClientLastName"
      fill_in "user_first_name", with: name
      fill_in "user_last_name", with: last_name
      fill_in "user_email", with: "client@example.com"
      fill_in "Zip Code", with: 94501
      fill_in "user_phone_number", with: "(510)555-5555"
      fill_in "user_password", with: "password"
      fill_in "confirm_password", with: "password"
      find("#user_signup_attributes_subject_id").find(:xpath, "option[2]").select_option
      find("#user_signup_attributes_student").find(:xpath, "option[2]").select_option
      click_button "Submit"

      expect(page).to have_current_path(new_clients_student_path)
      expect(page).to have_content(I18n.t("app.signup.client.success_message"))
      expect(page).to have_content(name)
      expect(page).to have_content(last_name)
      # Email count should be 2 since an email is sent to both client and admin
      expect(ActionMailer::Base.deliveries.count).to eq(2)
    end

    scenario "when user is student" do
      admin # creates admin user to check if email is sent to admin
      visit client_sign_up_path

      name = "StudentName"
      last_name = "StudentLastName"
      fill_in "user_first_name", with: name
      fill_in "user_last_name", with: last_name
      fill_in "user_email", with: "student@example.com"
      fill_in "Zip Code", with: 94501
      fill_in "user_phone_number", with: "(510)555-5555"
      fill_in "user_password", with: "password"
      fill_in "confirm_password", with: "password"
      find("#user_signup_attributes_subject_id").find(:xpath, "option[2]").select_option
      find("#user_signup_attributes_student").find(:xpath, "option[3]").select_option
      click_button "Submit"

      expect(page).to have_current_path(dashboard_path)
      expect(page).to have_content(I18n.t("app.signup.client_student.success_message"))
      expect(page).to have_content(name)
      expect(page).to have_content(last_name)
      # Email count should be 2 since an email is sent to both client and admin
      expect(ActionMailer::Base.deliveries.count).to eq(2)
    end

    scenario "when user is tutor" do
      admin
      visit new_users_tutor_path

      name = "TutorName"
      last_name = "TutorLastName"
      fill_in "user_first_name", with: name
      fill_in "user_last_name", with: last_name
      fill_in "user_phone_number", with: "(510)555-5555"
      fill_in "user_email", with: "tutor@example.com"
      fill_in "user_password", with: "password"
      fill_in "confirm_password", with: "password"
      check "agreement"
      click_button "Sign up"

      expect(page).to have_current_path(dashboard_path)
      expect(page).to have_content(I18n.t("app.signup.tutors.success"))
      expect(page).to have_content(name)
      expect(page).to have_content(last_name)
    end
  end

  context "with invalid params" do
    scenario "with an invalid email" do
      visit client_sign_up_path

      fill_in "user_first_name", with: "StudentName"
      fill_in "user_last_name", with: "StudentLastName"
      fill_in "user_phone_number", with: "(510)555-5555"
      fill_in "Zip Code", with: 94501
      fill_in "user_email", with: "student"
      fill_in "user_password", with: "password"
      fill_in "confirm_password", with: "password"
      click_button "Submit"

      expect(page).to have_content("Email is invalid")
    end

    scenario "when password does not match" do
      visit client_sign_up_path

      fill_in "user_first_name", with: "StudentName"
      fill_in "user_last_name", with: "StudentLastName"
      fill_in "user_phone_number", with: "(510)555-5555"
      fill_in "Zip Code", with: 94501
      fill_in "user_email", with: "student@example.com"
      fill_in "user_password", with: "password"
      fill_in "confirm_password", with: "notpassword"
      click_button "Submit"

      expect(page).to have_content(I18n.t("app.signup.password_fail"))
    end

    scenario "when user is tutor" do
      exisiting_email = "tutor@example.com"
      FactoryBot.create(:tutor_user, email: exisiting_email)
      visit new_users_tutor_path

      fill_in "user_first_name", with: "NewTutorName"
      fill_in "user_last_name", with: "NewTutorLastName"
      fill_in "user_phone_number", with: "(510)555-5555"
      fill_in "user_email", with: exisiting_email
      fill_in "user_password", with: "password"
      fill_in "confirm_password", with: "password"
      check "agreement"
      click_button "Sign up"

      expect(page).to have_content("Email has already been taken")
    end

    scenario "when user is tutor and does not check agreement" do
      visit new_users_tutor_path

      fill_in "user_first_name", with: "NewTutorName"
      fill_in "user_last_name", with: "NewTutorLastName"
      fill_in "user_phone_number", with: "(510)555-5555"
      fill_in "user_email", with: "tutor@example.com"
      fill_in "user_password", with: "password"
      fill_in "confirm_password", with: "password"
      click_button "Sign up"

      expect(page).to have_content(I18n.t("app.signup.tutors.agreement_fail"))
    end
    context "when user is from another country" do
      scenario "and inputs a valid phone number" do
        visit client_sign_up_path
        allow_any_instance_of(Users::ClientsController).to receive(:country_code) { "KR" }

        name = "ClientName"
        last_name = "ClientLastName"
        fill_in "user_first_name", with: name
        fill_in "user_last_name", with: last_name
        fill_in "user_email", with: "client@example.com"
        fill_in "user_phone_number", with: "02-312-3456"
        fill_in "Zip Code", with: 94501 # not a korean zip, but required currently
        fill_in "user_password", with: "password"
        fill_in "confirm_password", with: "password"
        find("#user_signup_attributes_subject_id").find(:xpath, "option[2]").select_option
        find("#user_signup_attributes_student").find(:xpath, "option[2]").select_option
        click_button "Submit"

        expect(page).to have_content(I18n.t("app.signup.client.success_message"))
        expect(page).to have_content(name)
        expect(page).to have_content(last_name)
      end

      scenario "and inputs a valid phone number" do
        visit client_sign_up_path
        allow_any_instance_of(Users::ClientsController).to receive(:country_code) { "KR" }

        fill_in "user_first_name", with: "Client"
        fill_in "user_last_name", with: "Last Name"
        fill_in "user_email", with: "client@example.com"
        fill_in "user_phone_number", with: "555-5555" # invalid korean number
        fill_in "Zip Code", with: 94501 # not a korean zip, but required currently
        fill_in "user_password", with: "password"
        fill_in "confirm_password", with: "password"
        find("#user_signup_attributes_subject_id").find(:xpath, "option[2]").select_option
        find("#user_signup_attributes_student").find(:xpath, "option[2]").select_option
        click_button "Submit"

        expect(page).to have_content("Phone number is invalid")
      end
    end
  end
end
