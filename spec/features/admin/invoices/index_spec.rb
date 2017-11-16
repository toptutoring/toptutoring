require 'rails_helper'

feature 'Invoices Index' do
  let(:tutor) { FactoryGirl.create(:tutor_user) }
  let(:client) { FactoryGirl.create(:client_user) }
  let(:student) { FactoryGirl.create(:student_user, client: client) }
  let(:admin) { FactoryGirl.create(:admin_user) }
  let!(:engagement) { FactoryGirl.create(:engagement, tutor: tutor, student: student, student_name: student.name, client: client) }
  let!(:invoice) { FactoryGirl.create(:invoice, submitter: tutor, client: client, engagement: engagement, status: "pending", hourly_rate: 59, hours: 1) }

  scenario 'when user is admin' do
    sign_in(admin)
    visit admin_invoices_path

    expect(page).to have_content('Invoices')
    expect(page).to have_content('Tutor')
    expect(page).to have_content('Date Submitted')
    expect(page).to have_content('Type')
    expect(page).to have_content('Client')
    expect(page).to have_content('Hours')
    expect(page).to have_content('Client Charge')
    expect(page).to have_content('Description')
    expect(page).to have_content('Tutor Pay')
    expect(page).to have_content('Status')
    expect(page).to have_content('Action')
    expect(page).to have_content(invoice.engagement.tutor.name)
    expect(page).to have_content(invoice.updated_at.strftime("%-m/%-e/%y"))
    expect(page).to have_content(invoice.engagement.academic_type)
    expect(page).to have_content(invoice.engagement.client.name)
    expect(page).to have_content(invoice.hours)
    expect(page).to have_content("59.00")
    expect(page).to have_content(invoice.description)
    expect(page).to have_content(invoice.status)
    expect(page).to have_content("$15.00")
    expect(page).not_to have_content('No Show')
  end

  scenario 'when invoice has a note' do
    invoice.update(note: 'No Show')
    sign_in(admin)
    visit admin_invoices_path

    expect(page).to have_content('No Show')
  end
end
