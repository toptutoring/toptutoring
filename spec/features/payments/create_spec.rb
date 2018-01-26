require 'rails_helper'

# TODO write full integration tests for payments feature. Pair.
# Stripe js not available in specs
feature "Create payment as client" do
  let(:client) { FactoryBot.create(:client_user) }
  let(:stripe_account) { FactoryBot.create(:stripe_account, user: client) }
  let(:engagement) { FactoryBot.create(:engagement, client_account: client.client_account) }

  scenario "when client has a stored card", js: true do
    engagement

    stripe_account
    sign_in(client)
    visit new_clients_payment_path

    expect(page).to have_content("Purchase Hours")
    expect(page).to have_content("Your Rate")
    expect(page).to have_content("Academic Hours")
    expect(page).to have_content("Credit card information")
    expect(page).to have_content(client.online_academic_rate.to_s)
    expect(page).to have_content(stripe_account.default_card_display)

    fill_in "payment_hours_purchased", with: 2
    click_on "Purchase Hours"

    payment = Payment.last
    expect(page).to have_content(I18n.t("app.payment.success"))
    expect(payment.payer).to eq client
    expect(payment.stripe_charge_id).to be_truthy
    expect(payment.last_four).to be_truthy
    expect(payment.card_brand).to be_truthy
    expect(payment.stripe_source).to be_truthy 
    expect(payment.stripe_account).to eq stripe_account
  end
end
