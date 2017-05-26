require 'spec_helper'

feature "Index Payments" do
  let(:client) { FactoryGirl.create(:client_user) }
  let(:payment) { FactoryGirl.create(:payment, payer_id: client.id, amount: 200,
                              status: "paid", description: "initial payment") }

  scenario "show all user's past payments" do
    payment

    sign_in(client)
    visit payments_path

    expect(page).to have_content(payment.created_at)
    expect(page).to have_content(payment.amount/100)
    expect(page).to have_content(payment.description)
  end
end
