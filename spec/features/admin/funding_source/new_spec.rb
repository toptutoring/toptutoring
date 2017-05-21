require 'spec_helper'

feature 'Set funding source' do
  let(:admin) { FactoryGirl.create(:admin_user) }
  let(:auth_admin) { FactoryGirl.create(:auth_admin_user) }

  scenario 'goes to new' do
    sign_in(admin)
    visit new_admin_funding_source_path
    expect(page).to have_current_path(new_admin_funding_source_path)
  end

  scenario "with invalid params" do
    sign_in(auth_admin)
    VCR.use_cassette('dwolla funding sources') do
      visit new_admin_funding_source_path
      click_button "Set Funding source"
      expect(page).to have_content("Funding source can't be blank")
    end
  end

  scenario "with valid params" do
    sign_in(auth_admin)
    VCR.use_cassette('dwolla funding sources') do
      visit new_admin_funding_source_path
      select "Balance", from: "funding_source_funding_source_id"
      click_button "Set Funding source"
      expect(page).to have_content("Funding source successfully set.")
    end
  end
end
