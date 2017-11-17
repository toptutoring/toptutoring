require 'rails_helper'

feature "Index Payments" do
  let(:client) { FactoryGirl.create(:client_user) }
  let(:payment) { FactoryGirl.create(:payment, payer_id: client.id, amount_cents: 200_00,
                                     status: "paid", description: "initial payment") }

  scenario "show all user's past payments" do
    payment

    sign_in(client)
    visit payments_path

    expect(page).to have_content(payment.created_at)
    expect(page).to have_content(payment.amount)
    expect(page).to have_content(payment.description)
  end
end
