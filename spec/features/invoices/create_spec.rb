require 'spec_helper'

feature 'Create Invoice' do
  scenario 'has valid form' do
    tutor = FactoryGirl.create(:tutor_user)
    student = FactoryGirl.create(:student_user)
    student.assignment.update(tutor_id: tutor.id)

    sign_in(tutor)
    visit tutors_students_path
    click_link "Log session"

    expect(page).to have_content('Use this form to log future sessions with your students.')
    expect(page).to have_content(student.name)
    expect(page).to have_content(student.assignment.subject)
  end

  scenario 'with invalid params' do
    tutor = FactoryGirl.create(:tutor_user)
    student = FactoryGirl.create(:student_user)
    student.assignment.update(tutor_id: tutor.id)

    sign_in(tutor)
    visit tutors_students_path
    click_link "Log session"

    fill_in "invoice_hours", with: 0
    click_on "Submit"
    expect(page).to have_content('Hours must be greater than or equal to 0.5')
  end

  scenario 'with valid params' do
    tutor = FactoryGirl.create(:tutor_user)
    student = FactoryGirl.create(:student_user)
    student.assignment.update(tutor_id: tutor.id)

    sign_in(tutor)
    visit tutors_students_path
    click_link "Log session"

    fill_in "invoice_hours", with: 0.5
    click_on "Submit"
    expect(page).to have_content('Session successfully logged!')
  end
end
