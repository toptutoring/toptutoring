require 'spec_helper'

feature 'Invoices Index' do
  scenario 'when user is admin' do
    tutor = FactoryGirl.create(:tutor_user)
    client = FactoryGirl.create(:client_user)
    student = FactoryGirl.create(:student_user, client: client)
    admin = FactoryGirl.create(:admin_user)
    engagement = FactoryGirl.create(:engagement, tutor: tutor, student: student, student_name: student.name, client: client)
    invoice = FactoryGirl.create(:invoice, tutor: tutor, engagement: engagement)

    sign_in(admin)
    visit admin_invoices_path

    expect(page).to have_content('Invoices')
    expect(page).to have_content('Client')
    expect(page).to have_content('Tutor')
    expect(page).to have_content('Subject')
    expect(page).to have_content('Academic Type')
    expect(page).to have_content('Description')
    expect(page).to have_content('Hours')
    expect(page).to have_content('Hourly Rate')
    expect(page).to have_content('Amount')
    expect(page).to have_content(invoice.engagement.client.name)
    expect(page).to have_content(invoice.engagement.tutor.name)
    expect(page).to have_content(invoice.engagement.subject)
    expect(page).to have_content(invoice.engagement.academic_type)
    expect(page).to have_content(invoice.description)
    expect(page).to have_content(invoice.hours)
    expect(page).to have_content(invoice.hourly_rate)
    expect(page).to have_content(invoice.amount)
    end
end
