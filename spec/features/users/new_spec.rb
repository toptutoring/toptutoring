require 'spec_helper'

feature 'New user' do
  scenario 'on student signup' do
    visit new_users_student_path

    expect(page).to have_content('Sign up')
    expect(page).to have_content('Name')
    expect(page).to have_content('Email')
    expect(page).to have_content('Password')
    expect(page).to have_content('Academic type')
    expect(page).to have_content('Sign up')
    expect(page).to have_content('By signing up, you agree to our terms of services and privacy policy.')
    expect(page).to have_content('Already have an account? Login')
  end

  scenario 'on tutor signup' do
    visit new_users_tutor_path

    expect(page).to have_content('Sign up')
    expect(page).to have_content('Name')
    expect(page).to have_content('Email')
    expect(page).to have_content('Password')
    expect(page).to have_content('Academic type')
    expect(page).to have_content('Sign up')
    expect(page).to have_content('By signing up, you agree to our terms of services and privacy policy.')
    expect(page).to have_content('Already have an account? Login')
  end
end
