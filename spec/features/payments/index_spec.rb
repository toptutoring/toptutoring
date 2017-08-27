require 'spec_helper'

feature "Index Payments" do
  let(:client) { FactoryGirl.create(:client_user) }
  let(:payment) { FactoryGirl.create(:payment, payer_id: client.id, amount_in_cents: 20000,
                              status: "paid", description: "initial payment") }
  let(:engagement) { FactoryGirl.create(:engagement, client: client, student_name: "student")}

  scenario "show all user's past payments" do
    engagement
    payment

    sign_in(client)
    visit payments_path

    expect(page).to have_content(payment.created_at)
    expect(page).to have_content(payment.amount)
    expect(page).to have_content(payment.description)
  end
end
