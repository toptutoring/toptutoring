require 'rails_helper'

feature 'as a contractor reviewing timesheets' do
  let(:contractor) { FactoryGirl.create(:tutor_user, roles: Role.where(name: ['tutor', 'contractor']), outstanding_balance: 1) }
  let!(:invoice) { FactoryGirl.create(:invoice, submitter: contractor, submitter_type: 'by_contractor', hours: 1) }

  scenario 'when user has a timesheet' do
    sign_in(contractor)
    visit timesheets_path

    expect(page).to have_content('Date Submitted')
    expect(page).to have_content('Total Hours')
    expect(page).to have_content('Description')
    expect(page).to have_content('Total Pay')
    expect(page).to have_content('Status')
    expect(page).to have_content('Actions')

    expect(page).to have_content(invoice.updated_at.strftime("%-m/%-e/%y"))
    expect(page).to have_content(invoice.hours)
    expect(page).to have_content(invoice.description)
    expect(page).to have_content(invoice.submitter_pay)
    expect(page).to have_content(invoice.status)
  end

  scenario 'when user deletes a timesheet' do
    sign_in(contractor)
    visit timesheets_path
    click_on 'Delete'

    expect(contractor.outstanding_balance).to eq 1
    expect(page).to have_content('Timesheet deleted')
    expect(contractor.reload.outstanding_balance).to eq 0
  end
end
