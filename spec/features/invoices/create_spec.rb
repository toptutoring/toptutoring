require 'spec_helper'

feature 'Create Invoice', js: true do
  let(:tutor) { FactoryGirl.create(:tutor_user) }
  let(:client) { FactoryGirl.create(:client_user, academic_credit: 50, test_prep_credit: 50) }
  let(:student) { FactoryGirl.create(:student_user, client: client) }
  let(:engagement) { FactoryGirl.create(:engagement, tutor: tutor, state: "active", student: student, student_name: student.name, academic_type: "Academic", client: client) }
  let(:invoice) { FactoryGirl.create(:invoice, tutor: tutor, client: client, engagement: engagement, student: student) }
  let(:email) { FactoryGirl.create(:email, tutor: tutor, client: client) }

  scenario 'has invoice form' do
    set_roles
    sign_in(tutor)

    expect(page).to have_content("Invoice session")
    expect(page).to have_content("Use this form to log past sessions with your students")
    expect(page).to have_content("Student")
    expect(page).to have_content("Hours")
    expect(page).to have_content("Main Subject Covered")
    expect(page).to have_content("Description")
  end

  scenario 'with valid invoice params' do
    set_roles
    student
    engagement

    sign_in(tutor)

    find('.hours').find(:xpath, 'option[1]').select_option
    fill_in "invoice[subject]", with: "Mathmatics"
    fill_in "Description", with: "for this weeks payment"

    click_on "Create Invoice"

    expect(page).to have_content("Session successfully logged!")

    sign_out
  end

  scenario 'low balance warning' do
    set_roles
    student
    engagement
    engagement.client.update(academic_credit: 0.0)

    sign_in(tutor)

    find('.hours').find(:xpath, 'option[3]').select_option
    fill_in "invoice[subject]", with: "Mathmatics"
    fill_in "Description", with: "for this weeks payment"

    click_on "Create Invoice"

    expect(page).to have_content("The session has been logged but
              the client has a negative balance of hours. You may not be paid
              for this session unless the client adds to his/her hourly balance")
  end
end
