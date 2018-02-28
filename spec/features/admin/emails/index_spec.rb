require 'rails_helper'

feature 'Emails Index' do
  scenario 'when user is admin' do
    admin = FactoryBot.create(:admin_user)
    tutor = FactoryBot.create(:tutor_user)
    client = FactoryBot.create(:client_user)
    student_account = FactoryBot.create(:student_account, client_account: client.client_account)
    engagement = FactoryBot.create(:engagement,
                                    client_account: client.client_account,
                                    student_account: student_account,
                                    tutor_account: tutor.tutor_account
                                  )
    invoice = FactoryBot.create(:invoice, submitter: tutor, engagement: engagement, client: client)
    email = FactoryBot.create(:email, tutor: tutor, client: client)

    sign_in(admin)
    visit admin_emails_path

    expect(page).to have_content('Client')
    expect(page).to have_content('Body')
    expect(page).to have_content('Date')
    expect(page).to have_content(email.client.full_name)
    expect(page).to have_content(email.body)
    expect(page).to have_content(email.created_at)
  end
end
