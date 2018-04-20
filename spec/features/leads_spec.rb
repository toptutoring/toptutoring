require "rails_helper"

feature "Leaving a comment" do
  before :each do
    unset_subdomain
  end

  after :each do
    set_subdomain("app")
  end

  scenario "with valid email and password", js: true do
    FactoryBot.create(:subject)
    visit "/contact"

    expect(Lead.count).to eq 0

    email = "email@example.com"
    first_name = "New"
    last_name = "Visitor"
    phone_number = "510-555-5555"
    zip = 94501
    fill_in "First Name", with: first_name
    fill_in "Last Name", with: last_name
    fill_in "Phone Number", with: phone_number
    fill_in "Email", with: email
    fill_in "Zip Code", with: zip
    find("#subject_id").find(:xpath, "option[2]").select_option
    click_button "Send Message"

    expect(page).to have_content(t "www.contact.confirmation")
    expect(Lead.last.email).to eq email
    expect(Lead.last.first_name).to eq first_name
    expect(Lead.last.last_name).to eq last_name
    expect(Lead.last.phone_number).to eq phone_number
    expect(Lead.last.zip).to eq zip
  end
end