require "rails_helper"

feature "User signs up as referral" do
  let(:admin) { User.admin }
  let(:client) { FactoryBot.create(:client_user) }
  let!(:subject_academic) { FactoryBot.create(:subject) }

  context "with valid params" do
    scenario "when user is a client that is not a student" do
      admin # creates admin user to check if email is sent to admin
      visit referral_path(client.unique_token)
      expect(page).to have_content(client.full_name)

      count_at_start = client.referrals.count
      name = "ClientName"
      last_name = "ClientLastName"
      fill_in "user_first_name", with: name
      fill_in "user_last_name", with: last_name
      fill_in "user_email", with: "client@example.com"
      fill_in "user_phone_number", with: "(510)555-5555"
      fill_in "user_password", with: "password"
      fill_in "confirm_password", with: "password"
      select subject_academic.name, from: "user_signup_attributes_subject_id"
      find("#user_signup_attributes_student").find(:xpath, "option[2]").select_option
      click_button "Submit"

      expect(page).to have_current_path(new_clients_student_path)
      expect(page).to have_content(I18n.t("app.signup.client.success_message"))
      expect(page).to have_content(name)
      expect(page).to have_content(last_name)
      # Email count should be 2 since an email is sent to both client and admin
      expect(ActionMailer::Base.deliveries.count).to eq(2)
      expect(User.last.referrer).to eq client
      expect(client.reload.referrals.count).to eq count_at_start + 1
    end
  end
end
