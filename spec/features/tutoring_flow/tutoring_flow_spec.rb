require 'spec_helper'

feature 'Tutoring flow' do
  scenario "client signup and set up account", js: true do
    director = FactoryGirl.create(:director_user)
    tutor = FactoryGirl.create(:tutor_user)

    visit new_users_client_path

    fill_in "user_name", with: "Client"
    fill_in "user_email", with: "client@example.com"
    fill_in "user_client_info_attributes_subject", with: "Math"
    fill_in "user_password", with: "password"
    choose "user_client_info_attributes_tutoring_for_1"
    click_button "Sign up"

    fill_in "user_phone_number", with: "0000000000"
    click_link "Next"

    fill_in "user_students_attributes_0_name", with: "Student"
    fill_in "user_students_attributes_0_email", with: "student@example.com"
    click_link "Finish"

    sign_out
    sign_in(director)

    expect(page).to have_content("Pending Assignments")
    click_link "Edit"

    select "Tutor", from: "assignment_tutor_id"
    fill_in "assignment_hourly_rate", with: "20"
    click_on "Submit"
    click_link "Enable"

    sign_out
    sign_in(tutor)

    fill_in "invoice_hours", with: "3"		
    fill_in "invoice_description", with: "Prep for math test"		
    click_on "Submit"		
    expect(page).to have_content("The session has been logged but the client 		
                    has a negative balance of hours. You may not be paid for this session 		
                    unless the client adds to his/her hourly balance.")		
 
    click_link "Students"
    click_link "Send Email"
    expect(page).to have_content("Use this form to notify the client that their tutoring balance is low.")
    expect(page).to have_field("email_body", with: "Tutor has invoiced 3.0 hours of tutoring for Math. You have 0 hours left in your hourly balance and payments must be made in advance before the next tutoring sessions.")
    click_on "Submit"
    sign_out

    visit login_path
    fill_in 'Email', with: "client@example.com"
    fill_in 'Password', with: "password"
    click_button 'Login'
    expect(page).to have_content("-3.0 hrs balance")

    VCR.use_cassette('one time payment') do
      fill_in "amount", with: 60
      fill_in "name", with: "Client"
      fill_in "credit-card", with: "4242424242424242"
      check("save_payment_info")
      click_on "Pay"

      expect(page).to have_content("Payment successfully made!")
    end

    visit new_payment_path

    VCR.use_cassette('valid stripe card') do
      fill_in "hours", with: 3
      fill_in "amount", with: 60
      click_on "Pay"

      expect(page).to have_content("Payment successfully made.")
      expect(page).to have_content("-2.0 hrs balance")
    end
  end
end
