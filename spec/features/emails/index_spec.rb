require 'spec_helper'

feature 'Emails Index' do
  scenario 'when user is tutor' do
    tutor = FactoryGirl.create(:tutor_user)
    student = FactoryGirl.create(:student_user)
    student.engagement.update(tutor_id: tutor.id)
    invoice = FactoryGirl.create(:invoice, tutor: tutor, engagement: student.engagement)
    invoice.update(student_id: student.id)
    email = FactoryGirl.create(:email, tutor: tutor, client: student.client)

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
