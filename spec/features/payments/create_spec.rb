require 'spec_helper'

feature "Payments Index" do
  context "when user is admin" do
    scenario "and does not have external auth" do
      tutor = FactoryGirl.create(:tutor_user)
      admin = FactoryGirl.create(:admin_user)

      sign_in(admin)
      visit admin_tutors_path
      click_on "Pay tutor"

      fill_in "payment_amount", with: 200
      fill_in "payment_description", with: "Payment description"
      click_button "Send Payment"

      expect(page).to have_content("Something went wrong! Please contact your administrator.")
    end

    scenario 'and has external auth' do
      VCR.use_cassette('dwolla authetication') do
        tutor = FactoryGirl.create(:tutor_user)
        director = FactoryGirl.create(:director_user)
        admin = FactoryGirl.create(:auth_admin_user)

        sign_in(director)
        visit admin_tutors_path
        click_on "Pay tutor"

        fill_in "payment_amount", with: 200
        fill_in "payment_description", with: "Payment description"
        click_button "Send Payment"

        expect(page).to have_content('Payment is being processed.')
      end
    end
  end

  context "when user is director" do
    scenario "and admin does not have external auth" do
      tutor = FactoryGirl.create(:tutor_user, access_token: 'xxx', refresh_token: 'xxx')
      admin = FactoryGirl.create(:admin_user)
      director = FactoryGirl.create(:director_user)

      sign_in(director)
      visit admin_tutors_path
      click_on "Pay tutor"

      fill_in "payment_amount", with: 200
      fill_in "payment_description", with: "Payment description"
      click_button "Send Payment"

      expect(page).to have_content('Something went wrong! Please contact your administrator.')
    end

    scenario "and admin has external auth" do
      VCR.use_cassette('dwolla authetication') do
        tutor = FactoryGirl.create(:tutor_user)
        director = FactoryGirl.create(:director_user)
        admin = FactoryGirl.create(:auth_admin_user)

        sign_in(director)
        visit admin_tutors_path
        click_on "Pay tutor"

        fill_in "payment_amount", with: 200
        fill_in "payment_description", with: "Payment description"
        click_button "Send Payment"

        expect(page).to have_content('Payment is being processed.')
      end
    end

    scenario "and payment exceeds tutor's balance" do
      VCR.use_cassette('dwolla authetication') do
        tutor = FactoryGirl.create(:tutor_user, balance: 100)
        director = FactoryGirl.create(:director_user)
        admin = FactoryGirl.create(:auth_admin_user)

        sign_in(director)
        visit admin_tutors_path
        click_on "Pay tutor"

        fill_in "payment_amount", with: 200
        fill_in "payment_description", with: "Payment description"
        click_button "Send Payment"

        expect(page).to have_content('This exceeds the maximum payment for this tutor.
          Please contact an administrator if you have any questions')
      end
    end
  end
end
