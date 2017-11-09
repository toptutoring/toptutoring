require 'spec_helper'
require 'rails_helper'

feature 'Admin timesheet features' do
  let(:contractor) { FactoryGirl.create(:tutor_user, outstanding_balance: 1) }
  let(:admin) { FactoryGirl.create(:auth_admin_user) }
  let!(:timesheet) { FactoryGirl.create(:invoice, submitter: contractor, submitter_type: 'by_contractor', status: "pending", hours: 1) }
  let(:funding_source) { FactoryGirl.create(:funding_source, user_id: admin.id) }

  scenario 'when admin pays a timesheet' do
    funding_source
    VCR.use_cassette('dwolla_authentication', record: :new_episodes) do
      sign_in(admin)
      visit admin_timesheets_path

      expect(contractor.outstanding_balance).to eq 1

      click_on "Pay"

      expect(page).to have_content('Payment is being processed.')
      expect(contractor.reload.outstanding_balance).to eq 0
      expect(timesheet.reload.status).to eq 'paid'
    end
  end

  scenario 'when admin denies a timesheet' do
    sign_in(admin)
    visit admin_timesheets_path

    expect(contractor.outstanding_balance).to eq 1

    click_on "Deny"

    expect(page).to have_content('The timesheet has been denied.')
    expect(contractor.reload.outstanding_balance).to eq 0
    expect(timesheet.reload.status).to eq 'denied'
  end

  scenario 'when admin edits a timesheet' do
    sign_in(admin)
    visit admin_timesheets_path
    click_on "Edit"

    expect(contractor.outstanding_balance).to eq 1
    expect(page).to have_content('Submitter: ' + contractor.name)
    expect(page).to have_content('Description')
    expect(page).to have_content('Hours')

    fill_in "Description", with: "Changing Description"
    fill_in "Hours", with: 3
    
    click_on "Update"

    expect(contractor.reload.outstanding_balance).to eq 3
    expect(timesheet.reload.description).to eq "Changing Description"
    expect(timesheet.reload.status).to eq 'pending'
  end
end
