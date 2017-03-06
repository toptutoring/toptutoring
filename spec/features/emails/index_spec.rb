require 'spec_helper'

feature 'Emails Index' do
  scenario 'when user is tutor' do
    tutor = FactoryGirl.create(:tutor_user)
    parent = FactoryGirl.create(:parent_user)
    parent.student.assignment.update(tutor_id: tutor.id)
    invoice = FactoryGirl.create(:invoice, tutor: tutor, assignment: parent.student.assignment)
    invoice.update(student_id: parent.student.id)
    email = FactoryGirl.create(:email, tutor: tutor, parent: parent)

    sign_in(tutor)
    visit tutors_emails_path

    expect(page).to have_content('Parent')
    expect(page).to have_content('Body')
    expect(page).to have_content('Date')
    expect(page).to have_content(email.parent.name)
    expect(page).to have_content(email.body)
    expect(page).to have_content(email.created_at)
  end
end
