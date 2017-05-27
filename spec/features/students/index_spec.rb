require 'rails_helper'

feature 'Students Index' do
  let(:tutor) { FactoryGirl.create(:tutor_user, outstanding_balance: 20) }
  let(:client) { FactoryGirl.create(:client_user) }
  let(:student) { FactoryGirl.create(:student_user, client: client) }
  let!(:engagement) { FactoryGirl.create(:engagement, client: student.client, tutor: tutor, student: student, student_name: student.name) }

  scenario 'when user is tutor' do
    sign_in tutor

    visit tutors_students_path

    expect(page).to have_content('Students')
    expect(page).to have_content('Name')
    expect(page).to have_content('Email')
    expect(page).to have_content('Phone Number')
    expect(page).to have_content('Subject')
    expect(page).to have_content(engagement.student.name)
    expect(page).to have_content(engagement.student.email)
    expect(page).to have_content(engagement.student.phone_number)
    expect(page).to have_content(engagement.subject)
    end
end
