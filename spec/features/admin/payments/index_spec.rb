require 'spec_helper'

feature "Index payments" do
  let(:admin) { FactoryGirl.create(:admin_user) }
  let(:director) { FactoryGirl.create(:director_user) }
  let(:client) { FactoryGirl.create(:client_user) }
  let(:tutor) { FactoryGirl.create(:tutor_user) }
  let(:payment_client) { FactoryGirl.create(:payment, payer: client, amount_cents: 200_00, customer_id: "xxx") }
  let(:payment_director) { FactoryGirl.create(:payment, payer: director, payee: tutor, amount_cents: 200_00) }

  context "when user is director" do
    scenario "should see client payments" do
      payment_client
      sign_in(director)
      visit director_payments_path

      expect(page).to have_content("Client Payments")
      expect(page).to have_content("Client")
      expect(page).to have_content("Amount")
      expect(page).to have_content("Description")
      expect(page).to have_content("Status")
      expect(page).to have_content("Date")
      expect(page).to have_content(payment_client.payer.name)
      expect(page).to have_content(payment_client.amount)
      expect(page).to have_content(payment_client.description)
      expect(page).to have_content(payment_client.status)
      expect(page).to have_content(payment_client.created_at)
    end

    scenario "should see his tutor payments" do
      payment_director

      sign_in(director)
      visit director_payments_path

      expect(page).to have_content("Tutor Payments")
      expect(page).to have_content("Payer")
      expect(page).to have_content("Payee")
      expect(page).to have_content("Amount")
      expect(page).to have_content("Description")
      expect(page).to have_content("Status")
      expect(page).to have_content("Date")
      expect(page).to have_content(payment_director.payer.name)
      expect(page).to have_content(payment_director.payee.name)
      expect(page).to have_content(payment_director.amount)
      expect(page).to have_content(payment_director.description)
      expect(page).to have_content(payment_director.status)
      expect(page).to have_content(payment_director.created_at)
    end
  end

  context "when user is admin" do
    scenario "should see client payments" do
      payment_client

      sign_in(admin)
      visit admin_payments_path

      expect(page).to have_content("Client Payments")
      expect(page).to have_content("Client")
      expect(page).to have_content("Amount")
      expect(page).to have_content("Description")
      expect(page).to have_content("Status")
      expect(page).to have_content("Date")
      expect(page).to have_content(payment_client.payer.name)
      expect(page).to have_content(payment_client.amount)
      expect(page).to have_content(payment_client.description)
      expect(page).to have_content(payment_client.status)
      expect(page).to have_content(payment_client.created_at)
    end

    scenario "should see all tutor payments" do
      payment_director

      sign_in(admin)
      visit admin_payments_path

      expect(page).to have_content("Tutor Payments")
      expect(page).to have_content("Payer")
      expect(page).to have_content("Payee")
      expect(page).to have_content("Amount")
      expect(page).to have_content("Description")
      expect(page).to have_content("Status")
      expect(page).to have_content("Date")
      expect(page).to have_content(payment_director.payer.name)
      expect(page).to have_content(payment_director.payee.name)
      expect(page).to have_content(payment_director.amount)
      expect(page).to have_content(payment_director.description)
      expect(page).to have_content(payment_director.status)
      expect(page).to have_content(payment_director.created_at)
    end
  end
end
