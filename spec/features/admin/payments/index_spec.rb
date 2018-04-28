require 'rails_helper'

feature "Index payments" do
  let(:admin) { FactoryBot.create(:admin_user) }
  let(:director) { FactoryBot.create(:director_user) }
  let(:client) { FactoryBot.create(:client_user) }
  let(:tutor) { FactoryBot.create(:tutor_user) }
  let(:contractor) { FactoryBot.create(:contractor_user) }
  let(:client_payment) { FactoryBot.create(:payment, :hourly_purchase, payer: client, amount_cents: 200_00) }
  let(:payout) { FactoryBot.create(:payout, approver: admin, receiving_account: tutor.tutor_account, amount_cents: 150_00) }
  let(:contractor_payout) { FactoryBot.create(:payout, approver: admin, receiving_account: contractor.contractor_account, amount_cents: 150_00) }

  context "when user is director" do
    scenario "should see client payments" do
      client_payment
      sign_in(director)
      visit admin_payments_path

      expect(page).to have_content("Client Payments")
      expect(page).to have_content("Client")
      expect(page).to have_content("Amount")
      expect(page).to have_content("Status")
      expect(page).to have_content("Date")
      expect(page).to have_content(client_payment.payer.full_name)
      expect(page).to have_content(client_payment.amount)
      expect(page).to have_css("i.ion-checkmark-round")
      expect(page).to have_content(l(client_payment.created_at, format: :date))
    end

    scenario "should see tutor payments" do
      payout
      sign_in(director)
      visit admin_tutor_payouts_path

      expect(page).to have_content("Date")
      expect(page).to have_content("Tutor")
      expect(page).to have_content("Status")
      expect(page).to have_content("Amount")
      expect(page).to have_content(l(payout.created_at, format: :date))
      expect(page).to have_content(payout.payee.full_name)
      expect(page).to have_css("i.ion-clock")
      expect(page).to have_content(payout.amount)
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
      expect(page).to have_content("Status")
      expect(page).to have_content("Date")
      expect(page).to have_content(client_payment.payer.full_name)
      expect(page).to have_content(client_payment.amount)
      expect(page).to have_css("i.ion-checkmark-round")
      expect(page).to have_content(l(client_payment.created_at, format: :date))
    end

    scenario "should see all tutor payments" do
      payout
      sign_in(admin)
      visit admin_tutor_payouts_path

      expect(page).to have_content("Date")
      expect(page).to have_content("Tutor")
      expect(page).to have_content("Status")
      expect(page).to have_content("Amount")
      expect(page).to have_content(l(payout.created_at, format: :date))
      expect(page).to have_content(payout.payee.full_name)
      expect(page).to have_css("i.ion-clock")
      expect(page).to have_content(payout.amount)
    end

    scenario "should see all contractor payments" do
      contractor_payout
      sign_in(admin)
      visit admin_contractor_payouts_path

      expect(page).to have_content("Date")
      expect(page).to have_content("Contractor")
      expect(page).to have_content("Status")
      expect(page).to have_content("Amount")
      expect(page).to have_content(l(contractor_payout.created_at, format: :date))
      expect(page).to have_content(contractor_payout.payee.full_name)
      expect(page).to have_css("i.ion-clock")
      expect(page).to have_content(contractor_payout.amount)
    end
  end
end
