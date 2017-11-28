require 'rails_helper'

feature 'Students Index' do
  let(:tutor) { FactoryGirl.create(:tutor_user, outstanding_balance: 20) }
  let(:client_account) { FactoryGirl.create(:client_account) }
  let(:client) { client_account.user }
  let(:student_account) { FactoryGirl.create(:student_account, client_account: client_account) }
  let!(:engagement) { FactoryGirl.create(:engagement, client: client, tutor: tutor, student_account: student_account) }

  scenario 'when user is tutor' do
    sign_in tutor

    visit tutors_students_path

    expect(page).to have_content('Students')
    expect(page).to have_content('Name')
    expect(page).to have_content('Email')
    expect(page).to have_content('Phone Number')
    expect(page).to have_content('Subject')
    expect(page).to have_content('Tutoring Type')
    expect(page).to have_content('Credits')
    expect(page).to have_content(engagement.student_name)
    expect(page).to have_content(client.email)
    expect(page).to have_content(client.phone_number)
    expect(page).to have_content(engagement.subject.name)
    end
end
