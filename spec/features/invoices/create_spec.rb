require 'rails_helper'

feature 'Create Invoice', js: true do
  let(:tutor) { FactoryGirl.create(:tutor_user, outstanding_balance: 0) }
  let(:client) { FactoryGirl.create(:client_user, academic_credit: 50, test_prep_credit: 50) }
  let(:student) { FactoryGirl.create(:student_user, client: client) }
  let(:engagement) { FactoryGirl.create(:engagement, tutor: tutor, state: "active", student: student, student_name: student.name, academic_type: "Academic", client: client) }
  let(:invoice) { FactoryGirl.create(:invoice, submitter: tutor, client: client, engagement: engagement, student: student) }
  let(:email) { FactoryGirl.create(:email, tutor: tutor, client: client) }

  context "tutor" do
    scenario 'has invoice form' do
      sign_in(tutor)

      expect(page).to have_content("Invoice session")
      expect(page).to have_content("Use this form to log past sessions with your students")
      expect(page).to have_content("Student")
      expect(page).to have_content("Hours")
      expect(page).to have_content("Main Subject Covered")
      expect(page).to have_content("Description")
    end

    scenario 'creates invoice with valid params' do
      student
      engagement

      sign_in(tutor)

      find('.hours').find(:xpath, 'option[3]').select_option
      fill_in "invoice[subject]", with: "Mathmatics"
      fill_in "Description", with: "for this weeks payment"

      click_on "Create Invoice"

      expect(page).to have_content("Invoice has been created.")
      expect(tutor.reload.outstanding_balance).to eq(0.5)
      expect(client.reload.academic_credit).to eq(49.5)

      sign_out
    end

    scenario 'creates invoice as no show' do
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

    scenario 'creates invoice but client has a low balance' do
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

    scenario 'creates timesheet' do
      student
      engagement
      tutor.roles << Role.where(name: 'contractor')
      sign_in(tutor)

      find('#invoice_submitter_type').find(:xpath, 'option[3]').select_option
      find('.hours').find(:xpath, 'option[2]').select_option
      fill_in "Description", with: "Work"

      click_on "Create Invoice"

      expect(page).to have_content("Timesheet has been created.")
      expect(tutor.reload.outstanding_balance).to eq(1)

      sign_out
    end
  end
end
