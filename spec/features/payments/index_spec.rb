require 'spec_helper'

feature "Index Payments" do
  before(:all) do
    set_roles
  end
  scenario "show all user's past payments" do
    client = FactoryGirl.create(:client_user)
    payment = FactoryGirl.create(:payment, payer: client, amount: 20000)
    sign_in(client)

    visit payments_path

    expect(page).to have_content(payment.created_at)
    expect(page).to have_content(payment.amount/100)
    expect(page).to have_content(payment.description)
  end
end
