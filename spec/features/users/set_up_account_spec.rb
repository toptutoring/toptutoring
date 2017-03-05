require 'spec_helper'

feature 'Set up account' do
  let(:parent) { FactoryGirl.create(:parent_user, assignment: nil, access_state: "disabled") }

  scenario "has user inputs prefilled correctly" do
    sign_in(parent)

    expect(page).to have_field("user_name", with: parent.name)
    expect(page).to have_field("user_email", with: parent.email)
  end

  scenario "has required fields validation", js: true do
    sign_in(parent)

    click_link "Next"
    click_link "Next"
    expect(page).to have_content("Student email This value is required.")
  end

  scenario "with valid params", js: true do
    sign_in(parent)

    fill_in "user_phone_number", with: "0000000000"
    click_link "Next"

    fill_in "user_student_attributes_name", with: "Student"
    fill_in "user_student_attributes_email", with: "student@example.com"
    fill_in "user_student_attributes_phone_number", with: "0000000000"
    fill_in "user_student_attributes_subject", with: "Math"
    click_link "Next"

    VCR.use_cassette('valid stripe account info') do
      fill_in "card_holder", with: "Parent"
      fill_in "credit_card", with: "4242424242424242"
      fill_in "cvc", with: "1234"
      click_link "Finish"

      expect(page).to have_content("We are in the process of assigning you a tutor.")
    end
  end
end
