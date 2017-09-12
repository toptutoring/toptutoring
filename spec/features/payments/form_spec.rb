require 'spec_helper'

feature "Navigate to payment as client" do
  let(:client) { FactoryGirl.create(:client_user) }
  let(:engagement) { FactoryGirl.create(:engagement, client: client, student_name: "student")}

  scenario "with valid payment form" do
    engagement
    sign_in(client)

    expect(page.current_path).to eq dashboard_path
  end
end
