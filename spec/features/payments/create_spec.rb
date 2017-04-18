require 'spec_helper'

feature "Create payment as client" do
  scenario "with a valid stripe card", js: true do
    VCR.use_cassette('valid stripe card') do
      set_roles
      tutor = FactoryGirl.create(:tutor_user)
      student = FactoryGirl.create(:student_user)
      student.engagement.update(tutor_id: tutor.id)
      client = student.client
      client.update(customer_id: "cus_A45BGhlr4VjDcJ", balance: 30)

      sign_in(client)

      fill_in "hours", with: 2
      fill_in "amount", with: 20
      click_on "Pay"
      expect(page).to have_content("Payment successfully made.")
      expect(page).to have_content("4.0 hrs balance")
    end
  end
end
