require 'spec_helper'

feature 'Dashboard Index' do
  scenario 'when user is tutor' do
    tutor = FactoryGirl.create(:tutor_user)
    student = FactoryGirl.create(:student_user)
    assignment = FactoryGirl.create(:assignment, tutor: tutor, student: student)

    sign_in(tutor)

    expect(page).to have_content('Your clients')
    expect(page).to have_content('Student Name')
    expect(page).to have_content('Subject')
    expect(page).to have_content('Academic Type')
    expect(page).to have_content('Balance')
    expect(page).to have_content('Status')
    expect(page).to have_content(assignment.student.name)
    expect(page).to have_content(assignment.subject)
    expect(page).to have_content(assignment.academic_type)
    expect(page).to have_content(assignment.state)
    expect(page).to have_content(assignment.student.client.balance)
  end

  scenario 'when user is tutor' do
    tutor = FactoryGirl.create(:tutor_user)
    student = FactoryGirl.create(:student_user)
    assignment = FactoryGirl.create(:assignment, tutor: tutor, student: student)

    sign_in(tutor)

    expect(page).to have_content('Your clients')
    expect(page).to have_content('Student Name')
    expect(page).to have_content('Subject')
    expect(page).to have_content('Academic Type')
    expect(page).to have_content('Status')
    expect(page).to have_content('Balance')
    expect(page).to have_content(assignment.student.name)
    expect(page).to have_content(assignment.subject)
    expect(page).to have_content(assignment.academic_type)
    expect(page).to have_content(assignment.state)
    expect(page).to have_content(assignment.student.client.balance)
  end

  scenario 'when user is director' do
    director = FactoryGirl.create(:director_user)
    student = FactoryGirl.create(:student_user)
    assignment = FactoryGirl.create(:assignment, student: student, state: "pending")

    sign_in(director)

    expect(page).to have_content('Pending Assignments')
    expect(page).to have_content('Student Name')
    expect(page).to have_content('Subject')
    expect(page).to have_content('Academic Type')
    expect(page).to have_content('Status')
    expect(page).to have_content(assignment.student.name)
    expect(page).to have_content(assignment.subject)
    expect(page).to have_content(assignment.academic_type)
    expect(page).to have_content(assignment.state)
    expect(page).to have_link("Edit")
  end
end
