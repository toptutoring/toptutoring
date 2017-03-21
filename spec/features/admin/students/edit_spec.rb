require 'spec_helper'

feature "Edit student" do
  scenario "has valid form" do
    admin = FactoryGirl.create(:admin_user)
    client = FactoryGirl.create(:client_user)

    sign_in(admin)
    visit edit_admin_user_path(client)

    expect(page).to have_field "user_balance", with: client.balance
  end

  scenario "is submitted successfully" do
    admin = FactoryGirl.create(:admin_user)
    client = FactoryGirl.create(:client_user)

    sign_in(admin)
    visit edit_admin_user_path(client)

    fill_in "user_balance", with: 200
    click_on "Submit"
    expect(page).to have_content("User successfully updated!")
  end
end
