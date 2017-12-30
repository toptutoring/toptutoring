require "rails_helper"

feature "Create payment for tutor" do
  let(:admin) { FactoryBot.create(:auth_admin_user) }
  let(:tutor) { FactoryBot.create(:tutor_user, name: "Authorized", outstanding_balance: 3) }
  let(:tutor_no_auth) { FactoryBot.create(:tutor_user, name: "None", auth_uid: nil, access_token: nil, refresh_token: nil) }
  let(:client) { FactoryBot.create(:client_user) }
  let(:student_account) { FactoryBot.create(:student_account, client_account: client.client_account) }
  let!(:engagement) { FactoryBot.create(:engagement, tutor_account: tutor.tutor_account, student_account: student_account, client_account: client.client_account) }
  let!(:engagement_no_auth) { FactoryBot.create(:engagement, tutor_account: tutor_no_auth.tutor_account, student_account: student_account, client_account: client.client_account) }
  let!(:invoice) { FactoryBot.create(:invoice, submitter: tutor, client: client, engagement: engagement, status: "pending", hourly_rate: 59, hours: 1) }
  let!(:invoice2) { FactoryBot.create(:invoice, submitter: tutor, client: client, engagement: engagement, status: "pending", hourly_rate: 59, hours: 2) }
  let!(:invoice3) { FactoryBot.create(:invoice, submitter: tutor_no_auth, client: client, engagement: engagement_no_auth, status: "pending", hourly_rate: 59, hours: 1) }
  let(:funding_source) { FactoryBot.create(:funding_source, user_id: admin.id) }

  context "when user is admin" do
    scenario "and attempts to pay invoice when funding source is not set" do
      sign_in(admin)
      visit admin_invoices_path
      click_on "Pay All Invoices"

      expect(page).to have_content("You must select a funding source before making a payment.")
    end

    scenario "makes payment for tutors with and without dwolla authentication" do
      VCR.use_cassette("dwolla_mass_payment", match_requests_on: [:method, :path]) do
        funding_source
        sign_in(admin)
        visit admin_invoices_path
        click_on "Pay All Invoices"

        expect(page).to have_content("There was an error making a payment for #{tutor_no_auth.name}. Payment was not processed.")
        expect(page).to have_content("1 payment has been made for a total of $45.00")
        expect(tutor.reload.outstanding_balance).to eq 0
      end
    end
  end
end
