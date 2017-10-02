require 'spec_helper'

feature 'Timesheet Index' do
  let(:tutor) { FactoryGirl.create(:tutor_user) }
  let(:client) { FactoryGirl.create(:client_user) }
  let(:student) { FactoryGirl.create(:student_user, client: client) }
  let(:admin) { FactoryGirl.create(:admin_user) }
  let!(:engagement) { FactoryGirl.create(:engagement, tutor: tutor, student: student, student_name: student.name, client: client) }
  let!(:timesheet) { FactoryGirl.create(:invoice, submitter: tutor, submitter_type: 'by_contractor', status: "pending", hours: 1) }

  scenario 'when user is admin' do
    sign_in(admin)
    visit admin_timesheets_path

    expect(page).to have_content('Timesheets')
    expect(page).to have_content('Submitted By')
    expect(page).to have_content('Date Submitted')
    expect(page).to have_content('Total Hours')
    expect(page).to have_content('Description')
    expect(page).to have_content('Total Pay')
    expect(page).to have_content('Status')
    expect(page).to have_content('Actions')
    expect(page).to have_content(timesheet.submitter.name)
    expect(page).to have_content(timesheet.updated_at.strftime("%-m/%-e/%y"))
    expect(page).to have_content(timesheet.hours)
    expect(page).to have_content(timesheet.description)
    expect(page).to have_content(timesheet.status)
    expect(page).to have_content("$15.00")
    end
end
