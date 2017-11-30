require 'rails_helper'

feature 'Invoices Index' do
  let(:tutor) { FactoryGirl.create(:tutor_user) }
  let(:client) { FactoryGirl.create(:client_user) }
  let(:student_account) { FactoryGirl.create(:student_account, client_account: client.client_account) }
  let(:engagement) { FactoryGirl.create(:engagement, tutor: tutor, student_account: student_account, client_account: client.client_account) }
  let!(:invoice) { FactoryGirl.create(:invoice, submitter: tutor, client: client, engagement: engagement) }

  scenario 'when user is tutor' do
    sign_in(tutor)
    visit tutors_invoices_path

    expect(page).to have_content('Invoices')
    expect(page).to have_content('Student')
    expect(page).to have_content('Subject')
    expect(page).to have_content('Academic Type')
    expect(page).to have_content('Date')
    expect(page).to have_content('Description')
    expect(page).to have_content('Hours')

    expect(page).to have_content(invoice.engagement.student.name)
    expect(page).to have_content(invoice.engagement.subject.name)
    expect(page).to have_content(invoice.engagement.academic_type.humanize)
    expect(page).to have_content(invoice.created_at)
    expect(page).to have_content(invoice.description)
    expect(page).to have_content(invoice.hours)
    end
end
