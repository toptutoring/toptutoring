require 'rails_helper'

feature "Create payment as client" do
  let(:client) { FactoryGirl.create(:client_user) }
  let(:engagement) { FactoryGirl.create(:engagement, client_account: client.client_account) }

  scenario "with a valid stripe card", js: true do
    VCR.use_cassette('valid stripe card') do
      engagement

      sign_in(client)
      visit new_clients_payment_path

      fill_in "Hours", with: 2

      click_button "Purchase Hours"

      expect(page).to have_content("Payment successfully made.")
    end
  end
end
