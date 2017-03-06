require 'spec_helper'

feature "Index payments" do
  context "when user is director" do
    scenario "should see parent payments" do
      director = FactoryGirl.create(:director_user)
      parent = FactoryGirl.create(:parent_user)
      payment = FactoryGirl.create(:payment, payer: parent, amount: 20000, customer_id: "xxx")

      sign_in(director)
      visit admin_payments_path

      expect(page).to have_content("Parent Payments")
      expect(page).to have_content("Parent")
      expect(page).to have_content("Amount")
      expect(page).to have_content("Description")
      expect(page).to have_content("Status")
      expect(page).to have_content("Date")
      expect(page).to have_content(payment.payer.name)
      expect(page).to have_content(payment.amount)
      expect(page).to have_content(payment.description)
      expect(page).to have_content(payment.status)
      expect(page).to have_content(payment.created_at)
    end

    scenario "should see his tutor payments" do
      director = FactoryGirl.create(:director_user)
      tutor = FactoryGirl.create(:tutor_user)
      payment = FactoryGirl.create(:payment, payer: director, payee: tutor, amount: 20000)

      sign_in(director)
      visit admin_payments_path

      expect(page).to have_content("Tutor Payments")
      expect(page).to have_content("Payer")
      expect(page).to have_content("Payee")
      expect(page).to have_content("Amount")
      expect(page).to have_content("Description")
      expect(page).to have_content("Status")
      expect(page).to have_content("Date")
      expect(page).to have_content(payment.payer.name)
      expect(page).to have_content(payment.payee.name)
      expect(page).to have_content(payment.amount)
      expect(page).to have_content(payment.description)
      expect(page).to have_content(payment.status)
      expect(page).to have_content(payment.created_at)
    end
  end

  context "when user is admin" do
    scenario "should see parent payments" do
      admin = FactoryGirl.create(:admin_user)
      parent = FactoryGirl.create(:parent_user)
      payment = FactoryGirl.create(:payment, payer: parent, amount: 20000, customer_id: "xxx")

      sign_in(admin)
      visit admin_payments_path

      expect(page).to have_content("Parent Payments")
      expect(page).to have_content("Parent")
      expect(page).to have_content("Amount")
      expect(page).to have_content("Description")
      expect(page).to have_content("Status")
      expect(page).to have_content("Date")
      expect(page).to have_content(payment.payer.name)
      expect(page).to have_content(payment.amount)
      expect(page).to have_content(payment.description)
      expect(page).to have_content(payment.status)
      expect(page).to have_content(payment.created_at)
    end

    scenario "should see all tutor payments" do
      admin = FactoryGirl.create(:admin_user)
      director = FactoryGirl.create(:director_user)
      tutor = FactoryGirl.create(:tutor_user)
      payment = FactoryGirl.create(:payment, payer: director, payee: tutor, amount: 20000, destination: "xxx")

      sign_in(admin)
      visit admin_payments_path

      expect(page).to have_content("Tutor Payments")
      expect(page).to have_content("Payer")
      expect(page).to have_content("Payee")
      expect(page).to have_content("Amount")
      expect(page).to have_content("Description")
      expect(page).to have_content("Status")
      expect(page).to have_content("Date")
      expect(page).to have_content(payment.payer.name)
      expect(page).to have_content(payment.payee.name)
      expect(page).to have_content(payment.amount)
      expect(page).to have_content(payment.description)
      expect(page).to have_content(payment.status)
      expect(page).to have_content(payment.created_at)
    end
  end
end
