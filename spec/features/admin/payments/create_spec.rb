require 'spec_helper'

feature "Create payment for tutor" do
  let(:admin) { FactoryGirl.create(:admin_user) }
  let(:tutor) { FactoryGirl.create(:tutor_user, outstanding_balance: 10) }
  let(:client) { FactoryGirl.create(:client_user) }
  let(:student) { FactoryGirl.create(:student_user, client: client) }
  let(:contract) { FactoryGirl.create(:contract, user_id: tutor.id, hourly_rate: 20) }
  let(:director) { FactoryGirl.create(:director_user) }
  let(:engagement) { FactoryGirl.create(:engagement, student: student, tutor: tutor, client: client) }
  let(:funding_source) { FactoryGirl.create(:funding_source, user_id: admin.id) }

  context "when user is admin" do
    scenario "and does not have external auth" do
      tutor
      sign_in(admin)
      visit admin_tutors_path
      click_on "Pay tutor"

      find('.tutor').find(:xpath, 'option[1]').select_option
      fill_in "payment_amount", with: 100
      fill_in "payment_description", with: "Admin Payment description"
      click_button "Send Payment"

      expect(page).to have_content("You must authenticate with Dwolla and select a funding source before making a payment.")
    end

    scenario 'and has dwolla auth' do
      tutor
      funding_source
      VCR.use_cassette('dwolla authetication') do
        sign_in(admin)
        visit admin_tutors_path
        click_on "Pay tutor"

        find('.tutor').find(:xpath, 'option[2]').select_option
        fill_in "payment_amount", with: 10
        fill_in "payment_description", with: "Director Payment description"
        click_button "Send Payment"

        expect(page).to have_content('Payment is being processed.')
      end
    end
  end

  context "when user is director" do
    scenario "and admin does not have external auth" do
      sign_in(director)
      visit director_tutors_path
      click_on "Pay tutor"

      find('.tutor').find(:xpath, 'option[1]').select_option
      fill_in "payment_amount", with: 100
      fill_in "payment_description", with: "Payment description"
      click_button "Send Payment"

      expect(page).to have_content("Funding source isn't set yet. Please check your Dwolla account.")
    end

    scenario "and admin has external auth" do
      tutor
      engagement
      funding_source
      VCR.use_cassette('dwolla authetication') do
        sign_in(director)
        visit director_tutors_path
        click_on "Pay tutor"

        find('.tutor').find(:xpath, 'option[2]').select_option
        fill_in "payment_amount", with: 100
        fill_in "payment_description", with: "Payment description"
        click_button "Send Payment"

        expect(page).to have_content('Payment is being processed.')
      end
    end

    scenario "and payment exceeds tutor's balance" do
      VCR.use_cassette('dwolla authetication') do
        tutor
        funding_source
        sign_in(director)
        visit director_tutors_path
        click_on "Pay tutor"

        find('.tutor').find(:xpath, 'option[2]').select_option
        fill_in "payment_amount", with: 420
        fill_in "payment_description", with: "Payment description"
        click_button "Send Payment"

        expect(page).to have_content('This exceeds the maximum payment for this tutor.
          Please contact an administrator if you have any questions')
      end
    end

    scenario "and director pays himself" do
      VCR.use_cassette('dwolla authetication') do
        tutor
        contract
        funding_source

        sign_in(director)
        visit director_tutors_path
        click_on "Pay tutor"

        find('.tutor').find(:xpath, 'option[2]').select_option
        fill_in "payment_amount", with: 200
        fill_in "payment_description", with: "Payment description"

        click_button "Send Payment"

        expect(page).to have_content('Payment is being processed.')
        expect(page).to have_content("200")
      end
    end
  end
end
