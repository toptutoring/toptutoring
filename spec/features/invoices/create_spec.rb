require 'spec_helper'

feature 'Create Invoice' do
  before(:all) do
    set_roles
  end
  scenario 'has valid form' do
    tutor = FactoryGirl.create(:tutor_user)
    client = FactoryGirl.create(:client_user)
    client.students.first.ssignment.update(tutor_id: tutor.id)

    sign_in(tutor)
    visit tutors_students_path
    click_link "Log session"

    expect(page).to have_content('Use this form to log future sessions with your students.')
    expect(page).to have_content(client.students.first.name)
    expect(page).to have_content(client.students.first.assignment.subject)
  end

  scenario 'with invalid params' do
    tutor = FactoryGirl.create(:tutor_user)
    client = FactoryGirl.create(:client_user)
    client.students.first.assignment.update(tutor_id: tutor.id)

    sign_in(tutor)
    visit new_invoice_path(client)

    fill_in "invoice_hours", with: 0
    click_on "Submit"
    expect(page).to have_content('Hours must be greater than or equal to 0.5')
  end

  scenario 'with valid params' do
    tutor = FactoryGirl.create(:tutor_user)
    client = FactoryGirl.create(:client_user)
    client.students.first.assignment.update(tutor_id: tutor.id)

    sign_in(tutor)
    visit new_invoice_path(client)

    fill_in "invoice_hours", with: 0.5
    click_on "Submit"
    expect(page).to have_content('Session successfully logged!')
  end
end
