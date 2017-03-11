require 'spec_helper'

feature "Navigate to payment as client" do
  before(:all) do
    set_roles
  end
  scenario "with valid payment form" do
    client = FactoryGirl.create(:client_user, balance: 30)
    sign_in(client)

    expect(page.current_path).to eq payment_new_path
    expect(page).to have_content("1.0 hrs balance")
    expect(page).to have_content("This tutor has an hourly rate of $30.")
    expect(page).to have_field("hourly_rate", with: "30")
  end
end
