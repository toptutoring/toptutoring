require "rails_helper"

feature "Admin invoice features" do
  let(:tutor) { FactoryBot.create(:tutor_user) }
  let(:client) { FactoryBot.create(:client_user, online_test_prep_credit: 2) }
  let(:student_account) { FactoryBot.create(:student_account, client_account: client.client_account) }
  let(:test_prep_subject) { FactoryBot.create(:subject, academic_type: "test_prep") }
  let(:engagement) { FactoryBot.create(:engagement, tutor_account: tutor.tutor_account, subject: test_prep_subject, student_account: student_account, client_account: client.client_account) }
  let!(:invoice) { FactoryBot.create(:invoice, submitter: tutor, client: client, engagement: engagement, status: "pending", hourly_rate: 59, hours: 1) }
  let(:admin) { User.admin }
  let(:funding_source) { FactoryBot.create(:funding_source, user_id: admin.id) }

  scenario "when admin pays a single invoice" do
    funding_source

    transfer_url = "transfer_url"
    dwolla_stub_success(transfer_url)

    sign_in(admin)
    visit admin_invoices_path

    expect(tutor.tutor_account.balance_pending).to eq Money.new(15_00)

    click_on "Pay with Dwolla"

    payout = Payout.last
    expect(page).to have_content("Payment is being processed.")
    expect(tutor.tutor_account.reload.balance_pending).to eq 0
    expect(invoice.reload.status).to eq "processing"
    expect(invoice.reload.payout).to eq payout
    expect(payout.dwolla_transfer_url).to eq transfer_url
    expect(payout.status).to eq "processing"
  end

  scenario "when admin denies an invoice" do
    sign_in(admin)
    visit admin_invoices_path

    expect(tutor.tutor_account.balance_pending).to eq Money.new(15_00)
    expect(client.online_test_prep_credit).to eq 2

    click_on "Deny"

    expect(page).to have_content("The invoice has been denied.")
    expect(tutor.tutor_account.reload.balance_pending).to eq 0
    expect(client.reload.online_test_prep_credit).to eq 3
    expect(invoice.reload.status).to eq "denied"
  end

  scenario "when admin edits an invoice" do
    sign_in(admin)
    visit admin_invoices_path
    click_on "Edit"

    expect(tutor.tutor_account.balance_pending).to eq Money.new(15_00)
    expect(client.online_test_prep_credit).to eq 2
    expect(page).to have_content("Submitter: " + tutor.full_name)
    expect(page).to have_content("Description")
    expect(page).to have_content("Hours")

    fill_in "Description", with: "Changing Description"
    fill_in "Hours", with: 3

    click_on "Update"

    expect(tutor.tutor_account.reload.balance_pending).to eq Money.new(45_00)
    expect(invoice.reload.description).to eq "Changing Description"
    expect(client.reload.online_test_prep_credit).to eq 0
    expect(invoice.reload.status).to eq "pending"
  end
end
