require 'spec_helper'

feature 'Set up account' do
  let(:client) { FactoryGirl.create(:client_user, access_state: "disabled") }
  let(:client_as_student) { FactoryGirl.create(:client_user, :as_student, access_state: "disabled") }

#  scenario "has user inputs prefilled correctly" do
#    set_roles
#
#    sign_in(client)
#
#    expect(page).to have_field("user_name", with: client.name)
#    expect(page).to have_field("user_email", with: client.email)
#  end

  scenario "successfully when user has a student", js: true do
    set_roles

    sign_in(client)

    fill_in "user_phone_number", with: "0000000000"
    click_link "Next"

    fill_in "user_student_name", with: "Student"
    fill_in "user_student_email", with: "student@example.com"
    click_link "Finish"

    expect(page).to have_content("Make payment")
  end

  scenario "successfully when user doesn't provide a student email", js: true do
    set_roles

    sign_in(client)

    fill_in "user_phone_number", with: "0000000000"
    click_link "Next"

    fill_in "user_student_name", with: "Student"
    click_link "Finish"

    expect(page).to have_content("Make payment")
  end

  scenario "successfully when user is a student", js: true do
    set_roles

    sign_in(client_as_student)

    click_link "Next"
    select "Academic", from: "info_academic_type"
    click_link "Finish"

    expect(page).to have_content("Make payment")
  end
end
