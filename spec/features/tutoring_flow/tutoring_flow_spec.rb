require 'spec_helper'

feature 'Tutoring flow' do
  let(:director) { FactoryGirl.create(:director_user) }
  let!(:tutor) { FactoryGirl.create(:tutor_user) }
  let(:client) { FactoryGirl.create(:client_user) }
  let(:student) { FactoryGirl.create(:student_user, client: client) }

  scenario "client signup and set up account", js: true do
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

    expect(page).to have_content("Pending Engagements")
    click_link "Edit"

    select "Tutor", from: "engagement_tutor_id"
    click_on "Submit"
    click_link "Enable"

    sign_out

    sign_in tutor

    select "Student", from: "invoice_student_id"
    select "Academic", from: "academic_type"
    select "0", from: "invoice_hours"
    fill_in "invoice[subject]", with: "Mathmatics"
    fill_in "Description", with: "for this weeks payment"

    click_on "Submit"

    expect(page).to have_content("The session has been logged but the client
                  has a negative balance of hours. You may not be paid for this session
                  unless the client adds to his/her hourly balance.")

    visit tutors_students_path

    click_link "Students"
    click_link "Send Email"

    expect(page).to have_content("Use this form to notify the client that their tutoring balance is low.")

    click_on "Submit"
    sign_out

    visit login_path
    fill_in 'Email', with: "client@example.com"
    fill_in 'Password', with: "password"
    click_button 'Login'
    expect(page).to have_content("-0.5 hrs credit")

    VCR.use_cassette('one time payment') do
      fill_in "amount", with: 60
      fill_in "name", with: "Client"
      fill_in "credit-card", with: "4242424242424242"
      check("save_payment_info")
      click_on "Pay"

      expect(page).to have_content("Payment successfully made!")
    end
  end
end
