require 'spec_helper'

feature "Create payment as parent" do
  scenario "with an invalid stripe card", js: true do
    VCR.use_cassette('invalid stripe card') do
      parent = FactoryGirl.create(:parent_user, customer_id: "cus_9xET9cNmAJjO8A")
      sign_in(parent)

      fill_in "hours", with: 2
      expect(page).to have_field("amount", with: "60")
      click_on "Pay"

      expect(page).to have_content("Your card has expired.")
    end
  end

  scenario "with a valid stripe card", js: true do
    VCR.use_cassette('valid stripe card') do
      parent = FactoryGirl.create(:parent_user, customer_id: "cus_A45BGhlr4VjDcJ", balance: 30)
      sign_in(parent)

      fill_in "hours", with: 2
      expect(page).to have_field("amount", with: "60")
      click_on "Pay"

      expect(page).to have_content("Payment successfully made.")
      expect(page).to have_content("3.0 hrs balance")
    end
  end
end
