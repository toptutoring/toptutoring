require 'rails_helper'

feature 'Create Invoice', js: true do
  let(:tutor) { FactoryGirl.create(:tutor_user) }
  let(:client) { FactoryGirl.create(:client_user, academic_credit: 50, test_prep_credit: 50) }
  let(:student) { FactoryGirl.create(:student_user, client: client) }
  let(:engagement) { FactoryGirl.create(:engagement, tutor: tutor, state: "active", student: student, student_name: student.name, academic_type: "Academic", client: client) }
  let(:invoice) { FactoryGirl.create(:invoice, submitter: tutor, client: client, engagement: engagement, student: student) }
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

    expect(page).to have_content("Invoice has been created.")

    sign_out
  end

    scenario 'creates invoice as no show' do
      set_roles
      student
      engagement

      sign_in(tutor)

      find('.hours').find(:xpath, 'option[2]').select_option
      fill_in "invoice[subject]", with: "Mathmatics"
      fill_in "Description", with: "no show"

      click_on "Create Invoice"

      expect(page).to have_content("Invoice has been created.")
      expect(tutor.reload.outstanding_balance).to eq(0)
      expect(client.reload.academic_credit).to eq(50)
      expect(Invoice.last.note).to eq("No Show")

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

    expect(page).to have_content("Your invoice has been created. However, your client is running low on their balance. Please consider making a suggestion to your client to add to their balance before scheduling any more sessions.")
  end
end
