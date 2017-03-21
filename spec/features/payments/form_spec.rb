require 'spec_helper'

feature "Navigate to payment as client" do
  scenario "with valid payment form" do
    tutor = FactoryGirl.create(:tutor_user)
    student = FactoryGirl.create(:student_user)
    student.assignment.update(tutor_id: tutor.id)
    client = student.client

    sign_in(client)

    expect(page.current_path).to eq payment_new_path
    expect(page).to have_content("0.0 hrs balance")
    expect(page).to have_content("This tutor has an hourly rate of $20.")
    expect(page).to have_field("hourly_rate", with: "20.0")
  end
end
