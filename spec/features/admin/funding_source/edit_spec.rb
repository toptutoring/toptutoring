require 'spec_helper'

feature 'Edit funding source' do
  let(:admin) { FactoryGirl.create(:auth_admin_user) }

  scenario 'redirects to edit and has valid form' do
    admin = FactoryGirl.create(:auth_admin_user)
    funding_source = FactoryGirl.create(:funding_source)

    sign_in(admin)
    VCR.use_cassette('dwolla funding sources') do
      visit new_admin_funding_source_path
      expect(page).to have_current_path(edit_admin_funding_source_path(FundingSource.first))
      expect(page).to have_select("funding_source_funding_source_id", selected: "Balance")
    end
  end

  scenario "with invalid params" do
    admin = FactoryGirl.create(:auth_admin_user)

    sign_in(admin)
    VCR.use_cassette('dwolla funding sources') do
      visit new_admin_funding_source_path
      select "", from: "funding_source_funding_source_id"
      click_button "Set Funding source"
      expect(page).to have_content("Funding source can't be blank")
    end
  end

  scenario "with valid params" do
    admin = FactoryGirl.create(:auth_admin_user)

    sign_in(admin)
    VCR.use_cassette('dwolla funding sources') do
      visit new_admin_funding_source_path
      select "Superhero Savings Bank", from: "funding_source_funding_source_id"
      click_button "Set Funding source"
      expect(page).to have_content("Funding source successfully set.")
    end
  end
end
