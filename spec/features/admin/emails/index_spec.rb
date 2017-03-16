require 'spec_helper'

feature 'Emails Index' do
  before(:all) do
    set_roles
  end
  scenario 'when user is admin' do
    admin = FactoryGirl.create(:admin_user)
    tutor = FactoryGirl.create(:tutor_user)
    student = FactoryGirl.create(:student_user)
    student.assignment.update(tutor_id: tutor.id)
    invoice = FactoryGirl.create(:invoice, tutor: tutor, assignment: student.assignment)
    invoice.update(student_id: student.id)
    email = FactoryGirl.create(:email, tutor: tutor, client: student.client)

    sign_in(admin)
    visit admin_emails_path

    expect(page).to have_content('Client')
    expect(page).to have_content('Body')
    expect(page).to have_content('Date')
    expect(page).to have_content(email.client.name)
    expect(page).to have_content(email.body)
    expect(page).to have_content(email.created_at)
  end
end
