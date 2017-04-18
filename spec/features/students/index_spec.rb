require 'spec_helper'

feature 'Students Index' do
  scenario 'when user is tutor' do
    tutor = FactoryGirl.create(:tutor_user)
    student = FactoryGirl.create(:student_user)
    engagement = FactoryGirl.create(:engagement, tutor: tutor, student: student)

    sign_in(tutor)
    visit tutors_students_path

    expect(page).to have_content('Students')
    expect(page).to have_content('Name')
    expect(page).to have_content('Email')
    expect(page).to have_content('Phone Number')
    expect(page).to have_content('Subject')
    expect(page).to have_content('Balance')
    expect(page).to have_content(engagement.student.name)
    expect(page).to have_content(engagement.student.email)
    expect(page).to have_content(engagement.student.phone_number)
    expect(page).to have_content(engagement.subject)
    expect(page).to have_content(engagement.student.balance)
    end
end
