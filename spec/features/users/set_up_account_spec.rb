require 'spec_helper'

feature 'Set up account' do
  let(:client) { FactoryGirl.create(:client_user, access_state: "disabled") }

  scenario "has user inputs prefilled correctly" do
    set_roles

    sign_in(client)

    expect(page).to have_field("user_name", with: client.name)
    expect(page).to have_field("user_email", with: client.email)
  end

  scenario "with valid params", js: true do
    set_roles

    sign_in(client)

    fill_in "user_phone_number", with: "0000000000"
    click_link "Next"

    fill_in "user_students_attributes_0_name", with: "Student"
    fill_in "user_students_attributes_0_email", with: "student@example.com"
    click_link "Finish"

    expect(page).to have_content("Make payment")
  end
end
