require 'spec_helper'

feature 'Create user' do
  context "with valid params" do
    scenario 'when user is student' do
      visit new_users_client_path

      fill_in "user_name", with: 'student'
      fill_in "user_email", with: 'student@example.com'
      fill_in "user_password", with: 'password'
      choose "user_client_info_attributes_tutoring_for_1"
      click_button "Sign up"

      expect(page).to have_current_path(edit_user_path(User.first.id))
    end

    scenario 'when user is tutor' do
      visit new_users_tutor_path

      fill_in "user_name", with: 'tutor'
      fill_in "user_email", with: 'tutor@example.com'
      fill_in "user_password", with: 'password'
      click_button "Sign up"

      expect(page).to have_current_path(dashboard_path)
    end
  end

  context "with invalid params" do
    scenario 'when user is student' do
      visit new_users_client_path

      fill_in "user_name", with: 'student'
      fill_in "user_email", with: 'student'
      fill_in "user_password", with: 'password'
      click_button "Sign up"

      expect(page).to have_content('Email is invalid')
    end

    scenario 'when user is tutor' do
      visit new_users_tutor_path

      fill_in "user_name", with: 'tutor'
      fill_in "user_email", with: 'tutor@example.com'
      click_button "Sign up"

      expect(page).to have_content("Password can't be blank")
    end
  end
end
