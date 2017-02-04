require 'spec_helper'

feature 'Students Index' do
  scenario 'when user is tutor' do
    tutor = FactoryGirl.create(:tutor_user)
    parent = FactoryGirl.create(:parent_user)
    assignment = FactoryGirl.create(:assignment, tutor: tutor, student: parent)

    sign_in(tutor)
    visit tutors_students_path

    expect(page).to have_content('Students')
    expect(page).to have_content('Name')
    expect(page).to have_content('Email')
    expect(page).to have_content('Phone Number')
    expect(page).to have_content('Subject')
    expect(page).to have_content('Academic Type')
    expect(page).to have_content('Hourly Balance')
    expect(page).to have_content(assignment.student.student.name)
    expect(page).to have_content(assignment.student.student.email)
    expect(page).to have_content(assignment.student.phone_number)
    expect(page).to have_content(assignment.subject)
    expect(page).to have_content(assignment.academic_type)
    expect(page).to have_content(assignment.student.hourly_balance)
    end
end
