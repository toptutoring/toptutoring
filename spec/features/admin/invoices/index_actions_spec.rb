require 'rails_helper'

feature 'Admin invoice features' do
  let(:tutor) { FactoryGirl.create(:tutor_user, outstanding_balance: 2) }
  let(:client) { FactoryGirl.create(:client_user, test_prep_credit: 2) }
  let(:student_account) { FactoryGirl.create(:student_account, client_account: client.client_account) }
  let(:test_prep_subject) { FactoryGirl.create(:subject, academic_type: "test_prep") }
  let(:engagement) { FactoryGirl.create(:engagement, tutor: tutor, subject: test_prep_subject, student_account: student_account, client_account: client.client_account) }
  let!(:invoice) { FactoryGirl.create(:invoice, submitter: tutor, client: client, engagement: engagement, status: "pending", hourly_rate: 59, hours: 1) }
  let(:admin) { FactoryGirl.create(:auth_admin_user) }
  let(:funding_source) { FactoryGirl.create(:funding_source, user_id: admin.id) }

  scenario 'when admin pays a single invoice' do
    funding_source
    VCR.use_cassette('dwolla authentication', record: :new_episodes) do
      sign_in(admin)
      visit admin_invoices_path
      
      expect(tutor.outstanding_balance).to eq 2

      click_on "Pay"

      expect(page).to have_content('Payment is being processed.')
      expect(tutor.reload.outstanding_balance).to eq 1
      expect(invoice.reload.status).to eq 'paid'
    end
  end

  scenario 'when admin denies an invoice' do
    sign_in(admin)
    visit admin_invoices_path

    expect(tutor.outstanding_balance).to eq 2
    expect(client.test_prep_credit).to eq 2

    click_on "Deny"

    expect(page).to have_content('The invoice has been denied.')
    expect(tutor.reload.outstanding_balance).to eq 1
    expect(client.reload.test_prep_credit).to eq 3
    expect(invoice.reload.status).to eq 'denied'
  end

  scenario 'when admin edits an invoice' do
    sign_in(admin)
    visit admin_invoices_path
    click_on "Edit"

    expect(tutor.outstanding_balance).to eq 2
    expect(client.test_prep_credit).to eq 2
    expect(page).to have_content('Submitter: ' + tutor.name)
    expect(page).to have_content('Description')
    expect(page).to have_content('Hours')

    fill_in "Description", with: "Changing Description"
    fill_in "Hours", with: 3
    
    click_on "Update"

    expect(tutor.reload.outstanding_balance).to eq 4
    expect(invoice.reload.description).to eq "Changing Description"
    expect(client.reload.test_prep_credit).to eq 0
    expect(invoice.reload.status).to eq 'pending'
  end
end
