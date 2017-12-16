require 'rails_helper'

feature "Navigate to payment as client" do
  let(:client) { FactoryBot.create(:client_user) }

  scenario "with valid payment form" do
    FactoryBot.create(:engagement, client_account: client.client_account)
    sign_in(client)
    visit new_clients_payment_path

    expect(page.current_path).to eq new_clients_payment_path
  end
end
