require 'spec_helper'

feature 'Set funding source' do
  before(:all) do
    set_roles
  end
  scenario 'goes to new' do
    admin = FactoryGirl.create(:admin_user)

    sign_in(admin)
    visit new_admin_funding_source_path
    expect(page).to have_current_path(new_admin_funding_source_path)
  end

  scenario "with invalid params" do
    admin = FactoryGirl.create(:auth_admin_user)

    sign_in(admin)
    VCR.use_cassette('dwolla funding sources') do
      visit new_admin_funding_source_path
      click_button "Set Funding source"
      expect(page).to have_content("Funding source can't be blank")
    end
  end

  scenario "with valid params" do
    admin = FactoryGirl.create(:auth_admin_user)

    sign_in(admin)
    VCR.use_cassette('dwolla funding sources') do
      visit new_admin_funding_source_path
      select "Balance", from: "funding_source_funding_source_id"
      click_button "Set Funding source"
      expect(page).to have_content("Funding source successfully set.")
    end
  end
end
