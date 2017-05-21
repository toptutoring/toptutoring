require 'spec_helper'

feature 'Create Email' do
  let(:director) { FactoryGirl.create(:director_user) }
  let(:tutor) { FactoryGirl.create(:tutor_user) }
  let(:client) { FactoryGirl.create(:client_user) }
  let(:student) { FactoryGirl.create(:student_user, client: client) }
  let(:engagement) { FactoryGirl.create(:engagement, tutor: tutor, state: "active", student: student, client: client) }
  let(:invoice) { FactoryGirl.create(:invoice, tutor: tutor, engagement: engagement, student: student) }

  scenario 'has valid form' do
    invoice
    sign_in(tutor)
    visit tutors_students_path
    click_link "Send Email"

    expect(page).to have_content("Use this form to notify the client that their tutoring balance is low.")
    expect(page).to have_field("email_subject", with: "#{invoice.hours} hours of tutoring invoiced by #{tutor.name}")
    expect(page).to have_field("email_body", with: "#{tutor.name} has invoiced #{invoice.hours} hours of tutoring for #{engagement.subject}. You have #{client.credit_status(invoice) <= 0 ? 0 : client.credit_status(invoice)} hours left in your hourly balance and payments must be made in advance before the next tutoring sessions.")
  end

  scenario 'when I click submit' do
    invoice
    sign_in(tutor)
    visit new_email_path(student)

    click_on "Submit"
    expect(page).to have_content('Email has been sent!')
  end
end
