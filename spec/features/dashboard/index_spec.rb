require 'spec_helper'

feature 'Dashboard Index' do
  before(:all) do
    set_roles
  end
  scenario "when user doesn't have external auth" do
    tutor = FactoryGirl.create(:tutor_user, access_token: nil)

    sign_in(tutor)
    expect(page).to have_content('Authenticating with Dwolla')
    expect(page).to have_link('Authenticate with Dwolla', href: "/auth/dwolla")
  end

  scenario "when user has external auth" do
    tutor = FactoryGirl.create(:tutor_user)

    sign_in(tutor)
    expect(page).not_to have_content('Authenticating with Dwolla')
    expect(page).not_to have_link('Authenticate with Dwolla', href: "/auth/dwolla")
  end

  scenario 'when user is tutor' do
    tutor = FactoryGirl.create(:tutor_user)
    student = FactoryGirl.create(:student_user)
    assignment = FactoryGirl.create(:assignment, tutor: tutor, student: student)

    sign_in(tutor)

    expect(page).to have_content('Assignments')
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

  scenario 'when user is tutor' do
    tutor = FactoryGirl.create(:tutor_user)
    student = FactoryGirl.create(:student_user)
    assignment = FactoryGirl.create(:assignment, tutor: tutor, student: student)

    sign_in(tutor)

    expect(page).to have_content('Assignments')
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
