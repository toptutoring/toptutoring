require 'spec_helper'

feature 'Invoices Index' do
  scenario 'when user is tutor' do
    tutor = FactoryGirl.create(:tutor_user)
    student = FactoryGirl.create(:student_user)
    assignment = FactoryGirl.create(:assignment, tutor: tutor, student: student)
    invoice = FactoryGirl.create(:invoice, tutor: tutor, assignment: assignment)

    sign_in(tutor)
    visit tutors_invoices_path

    expect(page).to have_content('Invoices')
    expect(page).to have_content('Student')
    expect(page).to have_content('Subject')
    expect(page).to have_content('Academic Type')
    expect(page).to have_content('Date')
    expect(page).to have_content('Description')
    expect(page).to have_content('Hours')
    expect(page).to have_content('Hourly Rate')
    expect(page).to have_content('Amount')
    expect(page).to have_content(invoice.assignment.student.name)
    expect(page).to have_content(invoice.assignment.subject)
    expect(page).to have_content(invoice.assignment.academic_type)
    expect(page).to have_content(invoice.created_at)
    expect(page).to have_content(invoice.description)
    expect(page).to have_content(invoice.hours)
    expect(page).to have_content(invoice.hourly_rate)
    expect(page).to have_content(invoice.amount)
    end
end
