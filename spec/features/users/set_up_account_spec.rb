require 'rails_helper'

feature 'Set up account' do
  let(:client) { FactoryGirl.create(:client_user, access_state: "disabled") }
  let(:client_as_student) { FactoryGirl.create(:client_user, :as_student, access_state: "disabled") }
  let(:subject_test_prep) { FactoryGirl.create(:subject, tutoring_type: 'test_prep') }
  let(:signup_test_prep) { FactoryGirl.create(:signup, :as_student, subject: subject_test_prep.name) }
  let(:client_with_test_prep) { FactoryGirl.create(:client_user, :as_student, signup: signup_test_prep, access_state: "disabled") }

  context "new user signs up" do
    scenario "successfully when user has a student", js: true do
      sign_in(client)

      fill_in "user_phone_number", with: "0000000000"
      click_link "Next"

      student_name = 'Student Name'
      fill_in "user_student_name", with: student_name
      fill_in "user_student_email", with: "student@example.com"
      click_link "Finish"

      expect(page).to have_content(client.name)
      expect(page).to have_content("Dashboard")
      expect(page).to have_content(student_name)
      expect(page).to have_content("Thank you for finishing the sign up process!")
    end

    scenario "unsuccessfully when user provides an invalid phone number", js: true do
      sign_in(client_as_student)

      fill_in "user_phone_number", with: "1"
      click_link "Finish"

      expect(page).to have_content("Please input a valid phone number.")
    end

    scenario "successfully when user doesn't provide a student email", js: true do
      sign_in(client)

      fill_in "user_phone_number", with: "0000000000"
      click_link "Next"

      fill_in "user_student_name", with: "Student"
      click_link "Finish"
      expect(page).to have_content(client.name)
      expect(page).to have_content("Dashboard")
      expect(page).to have_content("Thank you for finishing the sign up process!")
    end

    scenario "successfully when user is a student", js: true do
      sign_in(client_as_student)
      fill_in "user_phone_number", with: "0000000000"
      click_link "Finish"

      expect(page).to have_content(client.name)
      expect(page).to have_content("Dashboard")
      expect(page).to have_content("Thank you for finishing the sign up process!")
    end

    scenario "successfully signs up with academic subject", js: true do
      sign_in(client_as_student)
      fill_in "user_phone_number", with: "0000000000"
      click_link "Finish"

      expect(page).to have_content(client_as_student.signup.subject)
      expect(page).to have_content("Academic")
      expect(page).to have_content("Thank you for finishing the sign up process!")
    end

    scenario "successfully signs up with test prep subject", js: true do
      sign_in(client_with_test_prep)
      fill_in "user_phone_number", with: "0000000000"
      click_link "Finish"

      expect(page).to have_content(subject_test_prep.name)
      expect(page).to have_content("Test Prep")
      expect(page).to have_content("Thank you for finishing the sign up process!")
    end
  end
end
