require 'spec_helper'

feature "Index Payments" do
  scenario "show all user's past payments" do
    parent = FactoryGirl.create(:parent_user)
    payment = FactoryGirl.create(:payment, payer: parent, amount: 20000)
    sign_in(parent)

    visit payments_path

    expect(page).to have_content(payment.created_at)
    expect(page).to have_content(payment.amount/100)
    expect(page).to have_content(payment.description)
  end
end
