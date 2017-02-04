require 'spec_helper'

feature 'Dashboard Index' do
  scenario 'when user is tutor' do
    tutor = FactoryGirl.create(:tutor_user)
    assignment = FactoryGirl.create(:assignment, tutor: tutor)

    sign_in(tutor)

    expect(page).to have_content('Assignments')
    expect(page).to have_content('#')
    expect(page).to have_content('Student Name')
    expect(page).to have_content('Subject')
    expect(page).to have_content('Academic Type')
    expect(page).to have_content('Status')
    expect(page).to have_content('Hourly balance')
    expect(page).to have_content(assignment.id)
    expect(page).to have_content(assignment.student.student.name)
    expect(page).to have_content(assignment.subject)
    expect(page).to have_content(assignment.academic_type)
    expect(page).to have_content(assignment.state)
    expect(page).to have_content(assignment.student.hourly_balance)
    end
end
