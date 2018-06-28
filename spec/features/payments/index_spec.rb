require 'rails_helper'

feature "Index Payments" do
  let(:client) { FactoryBot.create(:client_user) }
  let(:payment) { FactoryBot.create(:payment, :hourly_purchase, payer_id: client.id,
                                    amount_cents: 200_00, created_at: 3.days.ago,
                                    status: "paid", description: "initial payment") }
  let!(:refund) { FactoryBot.create(:refund, amount_cents: 20_00, payment: payment, created_at: 1.days.ago) }
  let(:other_payment) { FactoryBot.create(:payment, :hourly_purchase,
                                    amount_cents: 250_00, created_at: 5.days.ago,
                                    status: "paid") }
  let!(:other_refund) { FactoryBot.create(:refund, amount: 30_00, payment: other_payment, created_at: 4.days.ago) }

  scenario "show all user's past payments as well as refunds" do
    FactoryBot.create(:engagement, client_account: client.client_account)

    sign_in(client)
    visit new_clients_payment_path

    expect(page).to have_content(l(payment.created_at, format: :date))
    expect(page).to have_content(payment.amount)
    expect(page).to have_content(payment.description)
    expect(page).to have_content(l(refund.created_at, format: :date))
    expect(page).to have_content(refund.amount)
    expect(page).to have_content(t("app.clients.payments.refund_description", payment_date: l(payment.created_at, format: :date)))
    expect(page).not_to have_content(l(other_refund.created_at, format: :date))
    expect(page).not_to have_content(other_refund.amount)
    expect(page).not_to have_content(t("app.clients.payments.refund_description", payment_date: l(other_refund.payment.created_at, format: :date)))
    expect(page).not_to have_content(l(other_payment.created_at, format: :date))
    expect(page).not_to have_content(other_payment.amount)
    expect(page).not_to have_content(other_payment.description)
  end
end
