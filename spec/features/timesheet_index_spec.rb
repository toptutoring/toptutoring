require "rails_helper"

feature "as a contractor reviewing timesheets" do
  let(:contractor) { FactoryBot.create(:contractor_user) }
  let!(:invoice) { FactoryBot.create(:invoice, submitter: contractor, submitter_type: "by_contractor", hours: 1) }

  scenario "when user has a timesheet" do
    sign_in(contractor)
    visit timesheets_path

    expect(page).to have_content("Date Submitted")
    expect(page).to have_content("Total Hours")
    expect(page).to have_content("Description")
    expect(page).to have_content("Total Pay")
    expect(page).to have_content("Status")
    expect(page).to have_content("Actions")

    expect(page).to have_content(invoice.updated_at.strftime("%-m/%-e/%y"))
    expect(page).to have_content(invoice.hours)
    expect(page).to have_content(invoice.description)
    expect(page).to have_content(invoice.submitter_pay)
    expect(page).to have_content(invoice.status)
  end

  scenario "when user deletes a timesheet" do
    sign_in(contractor)
    visit timesheets_path
    expect(contractor.contractor_account.balance_pending).to eq Money.new(15_00)

    click_on "Delete"

    expect(page).to have_content("Timesheet deleted")
    expect(contractor.reload.contractor_account.balance_pending).to eq 0
  end
end
