require "rails_helper"

feature "Admin timesheet features" do
  let(:contractor) { FactoryBot.create(:contractor_user) }
  let(:admin) { FactoryBot.create(:auth_admin_user) }
  let!(:timesheet) { FactoryBot.create(:invoice, submitter: contractor, submitter_type: "by_contractor", status: "pending", hours: 1) }
  let(:funding_source) { FactoryBot.create(:funding_source, user_id: admin.id) }

  scenario "when admin pays a timesheet" do
    funding_source

    transfer_url = "transfer_url"
    dwolla_stub_success(transfer_url)

    sign_in(admin)
    visit admin_timesheets_path

    account = contractor.contractor_account
    expect(account.balance_pending).to eq Money.new(15_00)

    click_on "Pay"

    payout = Payout.last
    expect(page).to have_content("Payment is being processed.")
    expect(account.reload.balance_pending).to eq 0
    expect(timesheet.reload.status).to eq "processing"
    expect(timesheet.reload.payout).to eq payout
    expect(payout.dwolla_transfer_url).to eq transfer_url
    expect(payout.status).to eq "processing"
  end

  scenario "when admin denies a timesheet" do
    sign_in(admin)
    visit admin_timesheets_path

    account = contractor.contractor_account
    expect(account.balance_pending).to eq Money.new(15_00)

    click_on "Deny"

    expect(page).to have_content("The timesheet has been denied.")
    expect(account.reload.balance_pending).to eq 0
    expect(timesheet.reload.status).to eq "denied"
  end

  scenario "when admin edits a timesheet" do
    sign_in(admin)
    visit admin_timesheets_path
    click_on "Edit"

    account = contractor.contractor_account
    expect(account.balance_pending).to eq Money.new(15_00)
    expect(page).to have_content("Submitter: " + contractor.full_name)
    expect(page).to have_content("Description")
    expect(page).to have_content("Hours")

    fill_in "Description", with: "Changing Description"
    fill_in "Hours", with: 3
    
    click_on "Update"

    expect(account.reload.balance_pending).to eq Money.new(45_00)
    expect(timesheet.reload.description).to eq "Changing Description"
    expect(timesheet.reload.status).to eq "pending"
  end
end
