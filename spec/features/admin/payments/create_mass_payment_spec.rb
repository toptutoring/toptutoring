require 'rails_helper'

feature "Create payment for tutor" do
  let(:admin) { FactoryGirl.create(:auth_admin_user) }
  let(:tutor) { FactoryGirl.create(:tutor_user, name: "Authorized", outstanding_balance: 3) }
  let(:tutor_no_auth) { FactoryGirl.create(:tutor_user, name: "None", access_token: nil, refresh_token: nil) }
  let(:client) { FactoryGirl.create(:client_user) }
  let(:student) { FactoryGirl.create(:student_user, client: client) }
  let!(:engagement) { FactoryGirl.create(:engagement, tutor: tutor, student: student, student_name: student.name, client: client) }
  let!(:engagement) { FactoryGirl.create(:engagement, tutor: tutor_no_auth, student: student, student_name: student.name, client: client) }
  let!(:invoice) { FactoryGirl.create(:invoice, tutor: tutor, client: client, engagement: engagement, status: "pending", hourly_rate: 59, hours: 1) }
  let!(:invoice2) { FactoryGirl.create(:invoice, tutor: tutor, client: client, engagement: engagement, status: "pending", hourly_rate: 59, hours: 2) }
  let!(:invoice3) { FactoryGirl.create(:invoice, tutor: tutor_no_auth, client: client, engagement: engagement, status: "pending", hourly_rate: 59, hours: 1) }
  let(:funding_source) { FactoryGirl.create(:funding_source, user_id: admin.id) }

  context "when user is admin" do
    scenario "and attempts to pay invoice when funding source is not set" do
      sign_in(admin)
      visit admin_invoices_path
      click_on "Pay All Invoices"

      expect(page).to have_content("You must select a funding source before making a payment.")
    end

    scenario "makes payment for tutors with and without dwolla authentication" do
      VCR.use_cassette('dwolla_mass_payment') do
        funding_source
        sign_in(admin)
        visit admin_invoices_path
        click_on "Pay All Invoices"

        expect(page).to have_content("There was an error making a payment for #{tutor_no_auth.name}. Payment was not processed.")
        expect(page).to have_content('1 payment has been made for a total of $45.00')
        expect(tutor.reload.outstanding_balance).to eq 0
      end
    end
  end
end
