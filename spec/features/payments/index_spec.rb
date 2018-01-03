require 'rails_helper'

feature "Index Payments" do
  let(:client) { FactoryBot.create(:client_user) }
  let!(:payment) { FactoryBot.create(:payment, payer_id: client.id, amount_cents: 200_00,
                                     status: "paid", description: "initial payment") }

  scenario "show all user's past payments" do
    FactoryBot.create(:engagement, client_account: client.client_account)

    sign_in(client)
    visit clients_payments_path

    expect(page).to have_content(l(payment.created_at, format: :date))
    expect(page).to have_content(payment.amount)
    expect(page).to have_content(payment.description)
  end
end
