require 'spec_helper'

feature 'Create Email' do
  scenario 'has valid form' do
    tutor = FactoryGirl.create(:tutor_user)
    student = FactoryGirl.create(:student_user)
    student.engagement.update(tutor_id: tutor.id)
    invoice = FactoryGirl.create(:invoice, tutor: tutor, engagement: student.engagement)
    invoice.update(student_id: student.id)

    sign_in(tutor)
    visit tutors_students_path
    click_link "Send Email"

    expect(page).to have_content("Use this form to notify the client that their tutoring balance is low.")
    expect(page).to have_field("email_subject", with: "#{invoice.hours} hours of tutoring invoiced by #{tutor.name}")
    expect(page).to have_field("email_body", with: "#{tutor.name} has invoiced #{invoice.hours} hours of tutoring for #{student.engagement.subject}. You have #{student.client.hourly_balance(student) <= 0 ? 0 : student.client.hourly_balance(student)} hours left in your hourly balance and payments must be made in advance before the next tutoring sessions.")
  end

  scenario 'when I click submit' do
    tutor = FactoryGirl.create(:tutor_user)
    student = FactoryGirl.create(:student_user)
    student.engagement.update(tutor_id: tutor.id)
    invoice = FactoryGirl.create(:invoice, tutor: tutor, engagement: student.engagement)
    invoice.update(student_id: student.id)

    sign_in(tutor)
    visit new_email_path(student)

    click_on "Submit"
    expect(page).to have_content('Email has been sent!')
  end
end
