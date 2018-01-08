require 'rails_helper'

# TODO write full integration tests for payments feature. Pair.
feature "Create payment as client" do
  let(:client) { FactoryBot.create(:client_user) }
  let(:engagement) { FactoryBot.create(:engagement, client_account: client.client_account) }

  scenario "with a valid stripe card", js: true do
    VCR.use_cassette('valid stripe card') do
      engagement

      sign_in(client)
      visit new_clients_payment_path

      expect(page).to have_content("Purchase Hours")
      expect(page).to have_content("Your Rate")
      expect(page).to have_content("Academic Hours")
      expect(page).to have_content("Credit card information")
      expect(page).to have_content(client.academic_rate.to_s)
    end
  end
end
