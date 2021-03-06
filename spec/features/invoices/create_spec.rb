require "rails_helper"

feature "Create Invoice", js: true do
  let(:tutor) { FactoryBot.create(:tutor_user) }
  let(:tutor_invalid) { FactoryBot.create(:tutor_user, :invalid_record, phone_number: nil) }
  let(:client) { FactoryBot.create(:client_user, online_academic_credit: 50, online_test_prep_credit: 50) }
  let(:client_invalid) { FactoryBot.create(:client_user, :invalid_record, phone_number: nil, online_academic_credit: 50, online_test_prep_credit: 50) }
  let(:student) { FactoryBot.create(:student_user, client: client) }
  let(:engagement) { FactoryBot.create(:engagement, tutor_account: tutor.tutor_account, state: "active", student_account: student.student_account, client_account: client.client_account) }
  let(:invoice) { FactoryBot.create(:invoice, submitter: tutor, client: client, engagement: engagement, student: student) }
  let(:email) { FactoryBot.create(:email, tutor: tutor, client: client) }

  context "tutor" do
    scenario "has invoice form" do
      sign_in(tutor)

      expect(page).to have_content("Invoice session")
      expect(page).to have_content("Use this form to log past sessions with your students")
      expect(page).to have_content("Student")
      expect(page).to have_content("Hours")
      expect(page).to have_content("Main Subject Covered")
      expect(page).to have_content("Description")
    end

    scenario "creates invoice with valid params" do
      engagement

      sign_in(tutor)

      find("#invoice_hours").find(:xpath, "option[3]").select_option
      fill_in "invoice[subject]", with: "Mathmatics"
      find("label[for=invoice_session_rating_5]").click
      fill_in "Description", with: "for this weeks payment"

      click_on "Create Invoice"

      expect(page).to have_content("Invoice has been created.")
      expect(tutor.reload.tutor_account.balance_pending).to eq(Money.new(7_50))
      expect(client.reload.online_academic_credit).to eq(49.5)
    end

    scenario "legacy tutors without phone numbers do not prevent creation of invoice" do
      engagement.update(tutor_account: tutor_invalid.tutor_account)
      sign_in(tutor_invalid)

      find("#invoice_hours").find(:xpath, "option[3]").select_option
      find("label[for=invoice_session_rating_4]").click
      fill_in "invoice[subject]", with: "Mathmatics"
      fill_in "Description", with: "for this weeks payment"

      click_on "Create Invoice"

      expect(page).to have_content("Invoice has been created.")
      expect(tutor_invalid.reload.tutor_account.balance_pending).to eq(Money.new(7_50))
      expect(client.reload.online_academic_credit).to eq(49.5)
    end

    scenario "legacy clients without phone numbers do not prevent creation of invoice" do
      engagement.update(client_account: client_invalid.client_account)
      sign_in(tutor)

      find("#invoice_hours").find(:xpath, "option[3]").select_option
      fill_in "invoice[subject]", with: "Mathmatics"
      find("label[for=invoice_session_rating_3]").click
      fill_in "Description", with: "for this weeks payment"

      click_on "Create Invoice"

      expect(page).to have_content("Invoice has been created.")
      expect(tutor.reload.tutor_account.balance_pending).to eq(Money.new(7_50))
      expect(client_invalid.reload.online_academic_credit).to eq(49.5)
    end

    scenario "creates invoice as no show" do
      engagement

      sign_in(tutor)

      find("#invoice_hours").find(:xpath, "option[2]").select_option
      fill_in "invoice[subject]", with: "Mathmatics"
      find("label[for=invoice_session_rating_2]").click
      fill_in "Description", with: "no show"

      click_on "Create Invoice"

      expect(page).to have_content("Invoice has been created.")
      expect(tutor.reload.tutor_account.balance_pending).to eq(0)
      expect(client.reload.online_academic_credit).to eq(50)
      expect(Invoice.last.note).to eq("No Show")
    end

    scenario "creates invoice but client has a low balance" do
      engagement
      engagement.client.update(online_academic_credit: 0.0)

      sign_in(tutor)

      find("#invoice_hours").find(:xpath, "option[3]").select_option
      fill_in "invoice[subject]", with: "Mathmatics"
      find("label[for=invoice_session_rating_1]").click
      fill_in "Description", with: "for this weeks payment"

      click_on "Create Invoice"

      expect(page).to have_content("Your invoice has been created. However, your client is running low on their balance. Please consider making a suggestion to your client to add to their balance before scheduling any more sessions.")
    end

    scenario "creates timesheet" do
      engagement
      tutor.roles << Role.where(name: "contractor")
      tutor.create_contractor_account(hourly_rate: 15)
      sign_in(tutor)

      find("#invoice_submitter_type").find(:xpath, "option[3]").select_option
      find("#invoice_hours").find(:xpath, "option[2]").select_option
      fill_in "Description", with: "Work"

      click_on "Create Invoice"

      expect(page).to have_content("Timesheet has been created.")
      expect(tutor.reload.contractor_account.balance_pending).to eq(Money.new(15_00))
    end
  end
end
