require 'rails_helper'

feature "Navigate to payment as client" do
  let(:client) { FactoryGirl.create(:client_user) }

  scenario "with valid payment form" do
    sign_in(client)
    visit new_clients_payment_path

    expect(page.current_path).to eq new_clients_payment_path
  end
end
