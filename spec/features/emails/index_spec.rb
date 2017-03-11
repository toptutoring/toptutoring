require 'spec_helper'

feature 'Emails Index' do
  before(:all) do
    set_roles
  end
  scenario 'when user is tutor' do
    tutor = FactoryGirl.create(:tutor_user)
    client = FactoryGirl.create(:client_user)
    client.students.first.assignment.update(tutor_id: tutor.id)
    invoice = FactoryGirl.create(:invoice, tutor: tutor, assignment: client.students.first.assignment)
    invoice.update(student_id: client.students.first.id)
    email = FactoryGirl.create(:email, tutor: tutor, client: client)

    sign_in(tutor)
    visit tutors_emails_path

    expect(page).to have_content('Client')
    expect(page).to have_content('Body')
    expect(page).to have_content('Date')
    expect(page).to have_content(email.client.name)
    expect(page).to have_content(email.body)
    expect(page).to have_content(email.created_at)
  end
end
