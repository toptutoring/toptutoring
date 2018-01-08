require "rails_helper"

feature "Create user as first step of sign up process" do
  let(:admin) { FactoryBot.create(:admin_user) }
  let!(:subject_academic) { FactoryBot.create(:subject) }

  context "with valid params" do
    scenario "when user is a client that is not a student" do
      admin # creates admin user to check if email is sent to admin
      visit client_sign_up_path

      name = "Client"
      fill_in "user_name", with: name
      fill_in "user_email", with: "client@example.com"
      fill_in "user_phone_number", with: "(510)555-5555"
      fill_in "user_password", with: "password"
      find("#user_signup_attributes_subject_id").find(:xpath, "option[2]").select_option
      find("#user_signup_attributes_student").find(:xpath, "option[2]").select_option
      click_button "Submit"

      expect(page).to have_current_path(new_clients_student_path)
      expect(page).to have_content(I18n.t("app.signup.client.success_message"))
      expect(page).to have_content(name)
      # Email count should be 2 since an email is sent to both client and admin
      expect(ActionMailer::Base.deliveries.count).to eq(2)
    end

    scenario "when user is student" do
      admin # creates admin user to check if email is sent to admin
      visit client_sign_up_path

      name = "Student"
      fill_in "user_name", with: name
      fill_in "user_email", with: "student@example.com"
      fill_in "user_phone_number", with: "(510)555-5555"
      fill_in "user_password", with: "password"
      find("#user_signup_attributes_subject_id").find(:xpath, "option[2]").select_option
      find("#user_signup_attributes_student").find(:xpath, "option[3]").select_option
      click_button "Submit"

      expect(page).to have_current_path(dashboard_path)
      expect(page).to have_content(I18n.t("app.signup.client_student.success_message"))
      expect(page).to have_content(name)
      # Email count should be 2 since an email is sent to both client and admin
      expect(ActionMailer::Base.deliveries.count).to eq(2)
    end

    scenario "when user is tutor" do
      admin
      visit new_users_tutor_path

      fill_in "user_name", with: "tutor"
      fill_in "user_phone_number", with: "(510)555-5555"
      fill_in "user_email", with: "tutor@example.com"
      fill_in "user_password", with: "password"
      click_button "Sign up"

      expect(page).to have_current_path(dashboard_path)
      expect(page).to have_content(I18n.t("app.signup.tutors.success"))
    end
  end

  context "with invalid params" do
    scenario "with an invalid email" do
      visit client_sign_up_path

      fill_in "user_name", with: "student"
      fill_in "user_phone_number", with: "(510)555-5555"
      fill_in "user_email", with: "student"
      fill_in "user_password", with: "password"
      click_button "Submit"

      expect(page).to have_content("Email is invalid")
    end

    scenario "when user is tutor" do
      visit new_users_tutor_path

      fill_in "user_name", with: "tutor"
      fill_in "user_email", with: "tutor@example.com"
      click_button "Sign up"

      expect(page).to have_content("Password can't be blank")
    end
  end
end
