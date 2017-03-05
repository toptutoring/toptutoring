require 'spec_helper'

feature 'Create Invoice' do
  scenario 'has valid form' do
    tutor = FactoryGirl.create(:tutor_user)
    parent = FactoryGirl.create(:parent_user)
    assignment = FactoryGirl.create(:assignment, tutor: tutor, student: parent)

    sign_in(tutor)
    visit tutors_students_path
    click_link "Log session"

    expect(page).to have_content('Use this form to log future sessions with your students.')
    expect(page).to have_content(parent.student.name)
    expect(page).to have_content(assignment.subject)
  end

  scenario 'with invalid params' do
    tutor = FactoryGirl.create(:tutor_user)
    parent = FactoryGirl.create(:parent_user)
    assignment = FactoryGirl.create(:assignment, tutor: tutor, student: parent)

    sign_in(tutor)
    visit new_invoice_path(parent)

    fill_in "invoice_hours", with: 0
    click_on "Submit"
    expect(page).to have_content('Hours must be greater than or equal to 1')
  end

  scenario 'with valid params' do
    tutor = FactoryGirl.create(:tutor_user)
    parent = FactoryGirl.create(:parent_user)
    assignment = FactoryGirl.create(:assignment, tutor: tutor, student: parent)

    sign_in(tutor)
    visit new_invoice_path(parent)

    fill_in "invoice_hours", with: 1
    click_on "Submit"
    expect(page).to have_content('Session successfully logged!')
  end
end
