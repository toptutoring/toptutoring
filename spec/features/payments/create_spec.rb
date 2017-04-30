require 'spec_helper'

feature "Create payment as client" do
  let(:client) { FactoryGirl.create(:client_user, customer_id: "cus_A45BGhlr4VjDcJ") }

  scenario "with a valid stripe card", js: true do
    VCR.use_cassette('valid stripe card') do
      set_roles

      client

      sign_in(client)

      fill_in "Hours", with: 2
      fill_in "Description", with: "initial payment"

      click_on "Pay"

      expect(page).to have_content("Payment successfully made.")
    end
  end
end
