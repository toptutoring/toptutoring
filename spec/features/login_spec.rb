require 'rails_helper'

feature 'User logs in' do
  given(:user) { FactoryGirl.create(:tutor_user) }

  scenario 'with valid email and password' do
    visit login_path

    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Login'

    expect(page).to have_content('Logout')
    expect(page).to have_current_path(dashboard_path)
  end

  scenario 'with invalid email' do
    visit login_path

    fill_in 'Email', with: "test@example.com"
    fill_in 'Password', with: user.password
    click_button 'Login'

    expect(page).to have_content("Invalid email or password.")
    expect(page).to have_current_path(session_path)
  end

  scenario 'with invalid password' do
    visit login_path

    fill_in 'Email', with: user.email
    fill_in 'Password', with: ''
    click_button 'Login'

    expect(page).to have_content("Invalid email or password.")
    expect(page).to have_current_path(session_path)
  end

end
