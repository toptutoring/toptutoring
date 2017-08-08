require 'spec_helper'

feature 'Timesheet Index' do
  let(:tutor) { FactoryGirl.create(:tutor_user) }
  let(:client) { FactoryGirl.create(:client_user) }
  let(:student) { FactoryGirl.create(:student_user, client: client) }
  let(:admin) { FactoryGirl.create(:admin_user) }
  let!(:engagement) { FactoryGirl.create(:engagement, tutor: tutor, student: student, student_name: student.name, client: client) }
  let!(:timesheet) { FactoryGirl.create(:timesheet, user: tutor, status: "pending", minutes: 60) }

  scenario 'when user is admin' do
    sign_in(admin)
    visit admin_timesheets_path

    expect(page).to have_content('Timesheets')
    expect(page).to have_content('Submitted By')
    expect(page).to have_content('Date Submitted')
    expect(page).to have_content('Date of Work')
    expect(page).to have_content('Total Hours')
    expect(page).to have_content('Description')
    expect(page).to have_content('Total Pay')
    expect(page).to have_content('Actions')
    expect(page).to have_content(timesheet.user.name)
    expect(page).to have_content(timesheet.updated_at.strftime("%-m/%-e/%y"))
    expect(page).to have_content(timesheet.date.strftime("%-m/%-e/%y"))
    expect(page).to have_content(timesheet.hours)
    expect(page).to have_content(timesheet.description)
    expect(page).to have_content("$15.00")
    end
end
