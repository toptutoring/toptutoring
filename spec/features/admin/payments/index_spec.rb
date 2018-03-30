require 'rails_helper'

feature "Index payments" do
  let(:admin) { FactoryBot.create(:admin_user) }
  let(:director) { FactoryBot.create(:director_user) }
  let(:client) { FactoryBot.create(:client_user) }
  let(:tutor) { FactoryBot.create(:tutor_user) }
  let(:client_payment) { FactoryBot.create(:payment, :hourly_purchase, payer: client, amount_cents: 200_00) }
  let(:director_payout) { FactoryBot.create(:payout, approver: director, receiving_account: tutor.tutor_account, amount_cents: 200_00) }
  let(:admin_payout) { FactoryBot.create(:payout, approver: admin, receiving_account: tutor.tutor_account, amount_cents: 150_00) }

  context "when user is director" do
    scenario "should see client payments" do
      client_payment
      sign_in(director)
      visit director_payments_path

      expect(page).to have_content("Client Payments")
      expect(page).to have_content("Client")
      expect(page).to have_content("Amount")
      expect(page).to have_content("Description")
      expect(page).to have_content("Status")
      expect(page).to have_content("Date")
      expect(page).to have_content(client_payment.payer.full_name)
      expect(page).to have_content(client_payment.amount)
      expect(page).to have_content(client_payment.description)
      expect(page).to have_content(client_payment.status)
      expect(page).to have_content(l(client_payment.created_at, format: :date))
    end

    scenario "should see his tutor payments" do
      admin_payout
      director_payout
      sign_in(director)
      visit director_payments_path

      find_link("Tutor Payouts").click

      expect(page).to have_content("Date")
      expect(page).to have_content("Payee")
      expect(page).to have_content("Description")
      expect(page).to have_content("Status")
      expect(page).to have_content("Amount")
      expect(page).to have_content(l(director_payout.created_at, format: :date))
      expect(page).to have_content(director_payout.payee.full_name)
      expect(page).to have_content(director_payout.description)
      expect(page).to have_content(director_payout.status)
      expect(page).to have_content(director_payout.amount)
      expect(page).not_to have_content(admin_payout.amount)
    end
  end

  context "when user is admin" do
    scenario "should see client payments" do
      client_payment
      sign_in(admin)
      visit admin_payments_path

      expect(page).to have_content("Client Payments")
      expect(page).to have_content("Client")
      expect(page).to have_content("Amount")
      expect(page).to have_content("Description")
      expect(page).to have_content("Status")
      expect(page).to have_content("Date")
      expect(page).to have_content(client_payment.payer.full_name)
      expect(page).to have_content(client_payment.amount)
      expect(page).to have_content(client_payment.description)
      expect(page).to have_content(client_payment.status)
      expect(page).to have_content(l(client_payment.created_at, format: :date))
    end

    scenario "should see all tutor payments" do
      admin_payout
      director_payout
      sign_in(admin)
      visit admin_payments_path

      find_link("Tutor Payouts").click

      expect(page).to have_content("Date")
      expect(page).to have_content("Payee")
      expect(page).to have_content("Description")
      expect(page).to have_content("Status")
      expect(page).to have_content("Amount")
      expect(page).to have_content(l(director_payout.created_at, format: :date))
      expect(page).to have_content(director_payout.payee.full_name)
      expect(page).to have_content(director_payout.description)
      expect(page).to have_content(director_payout.status)
      expect(page).to have_content(director_payout.amount)
      expect(page).to have_content(admin_payout.amount)
    end
  end
end
