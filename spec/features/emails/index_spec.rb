require 'rails_helper'

feature 'Emails Index' do
  let(:tutor) { FactoryBot.create(:tutor_user) }
  let(:client) { FactoryBot.create(:client_user) }
  let(:student_account) { FactoryBot.create(:student_account, client_account: client.client_account) }
  let(:engagement) { FactoryBot.create(:engagement, tutor_account: tutor.tutor_account, state: "active", student_account: student_account, client_account: client.client_account) }
  let(:invoice) { FactoryBot.create(:invoice, submitter: tutor, engagement: engagement, student: student_account.user) }
  let(:email) { FactoryBot.create(:email, tutor: tutor, client: client) }

  scenario 'when user is tutor' do
    email

    sign_in(tutor)
    visit tutors_emails_path

    expect(page).to have_content('Client')
    expect(page).to have_content('Body')
    expect(page).to have_content('Date')
    expect(page).to have_content(email.client.full_name)
    expect(page).to have_content(email.body)
    expect(page).to have_content(email.created_at)
  end
end
