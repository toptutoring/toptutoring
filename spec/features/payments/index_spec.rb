require 'spec_helper'

feature "Index Payments" do
  scenario "show all user's past payments" do
    student = FactoryGirl.create(:student_user)
    payment = FactoryGirl.create(:payment, payer: student.client, amount: 20000)
    sign_in(student.client)

    visit payments_path

    expect(page).to have_content(payment.created_at)
    expect(page).to have_content(payment.amount/100)
    expect(page).to have_content(payment.description)
  end
end
