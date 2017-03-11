require 'spec_helper'

feature 'Set up account' do
  before(:all) do
    set_roles
  end
  let(:client) { FactoryGirl.create(:client_user, assignment: nil, access_state: "disabled") }

  scenario "has user inputs prefilled correctly" do
    sign_in(client)

    expect(page).to have_field("user_name", with: client.name)
    expect(page).to have_field("user_email", with: client.email)
  end

  scenario "has required fields validation", js: true do
    sign_in(client)

    click_link "Next"
    click_link "Next"
    expect(page).to have_content("Student email This value is required.")
  end

  scenario "with valid params", js: true do
    sign_in(client)

    fill_in "user_phone_number", with: "0000000000"
    click_link "Next"

    fill_in "user_student_info_attributes_name", with: "Student"
    fill_in "user_student_info_attributes_email", with: "student@example.com"
    fill_in "user_student_info_attributes_phone_number", with: "0000000000"
    fill_in "user_student_info_attributes_subject", with: "Math"
    click_link "Next"

    VCR.use_cassette('valid stripe account info') do
      fill_in "card_holder", with: "Client"
      fill_in "credit_card", with: "4242424242424242"
      fill_in "cvc", with: "1234"
      click_link "Finish"

      expect(page).to have_content("We are in the process of assigning you a tutor.")
    end
  end
end
