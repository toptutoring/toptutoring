require 'spec_helper'

feature 'Create Index' do
  scenario 'has valid form' do
    tutor = FactoryGirl.create(:tutor_user)
    parent = FactoryGirl.create(:parent_user)
    parent.student.assignment.update(tutor_id: tutor.id)
    invoice = FactoryGirl.create(:invoice, tutor: tutor, assignment: parent.student.assignment)
    invoice.update(student_id: parent.id)

    sign_in(tutor)
    visit tutors_students_path
    click_link "Send Email"

    expect(page).to have_content("Use this form to notify the client that their tutoring balance is low.")
    expect(page).to have_field("email_subject", with: "#{invoice.hours} hours of tutoring invoiced by #{tutor.name}")
    expect(page).to have_field("email_body", with: "#{tutor.name} has invoiced #{invoice.hours} hours of tutoring for #{parent.student.assignment.subject}. You have #{parent.hourly_balance <= 0 ? 0 : parent.hourly_balance} hours left in your hourly balance and payments must be made in advance before the next tutoring sessions.")
  end

  scenario 'when I click submit' do
    tutor = FactoryGirl.create(:tutor_user)
    parent = FactoryGirl.create(:parent_user)
    parent.student.assignment.update(tutor_id: tutor.id)
    invoice = FactoryGirl.create(:invoice, tutor: tutor, assignment: parent.student.assignment)
    invoice.update(student_id: parent.id)

    sign_in(tutor)
    visit new_email_path(parent)

    click_on "Submit"
    expect(page).to have_content('Email has been sent!')
  end
end
