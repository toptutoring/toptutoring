require "rails_helper"

feature "Timesheet Index" do
  let(:contractor) { FactoryBot.create(:contractor_user) }
  let(:admin) { User.admin }
  let!(:timesheet) { FactoryBot.create(:invoice, submitter: contractor, submitter_type: "by_contractor", status: "pending", hours: 1) }

  scenario "when user is admin" do
    sign_in(admin)
    visit admin_timesheets_path

    expect(page).to have_content("Timesheet")
    expect(page).to have_content("Submitted By")
    expect(page).to have_content("Date Submitted")
    expect(page).to have_content("Total Hours")
    expect(page).to have_content("Description")
    expect(page).to have_content("Total Pay")
    expect(page).to have_content("Status")
    expect(page).to have_content("Actions")
    expect(page).to have_content(timesheet.submitter.full_name)
    expect(page).to have_content(timesheet.updated_at.strftime("%-m/%-e/%y"))
    expect(page).to have_content(timesheet.hours)
    expect(page).to have_content(timesheet.description)
    expect(page).to have_content(timesheet.status)
    expect(page).to have_content("$15.00")
    end
end
