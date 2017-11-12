require 'spec_helper'
require "rails_helper"

feature "Director client index" do
  let!(:client) { FactoryGirl.create(:client_user) }
  let(:director) { FactoryGirl.create(:director_user) }

  scenario "when director visits index page" do
    sign_in(director)

    visit director_users_path

    expect(page).to have_content("ID")
    expect(page).to have_content(client.id)
    expect(page).to have_content("Name")
    expect(page).to have_content(client.name)
    expect(page).to have_content(client.email)
    expect(page).to have_content("Access State")
    expect(page).to have_content(client.access_state)
    expect(page).to have_content("Academic Rate")
    expect(page).to have_content(client.academic_rate)
    expect(page).to have_content("Test Prep Rate")
    expect(page).to have_content(client.test_prep_rate)
    expect(page).to have_content("Academic Credit")
    expect(page).to have_content(client.academic_credit)
    expect(page).to have_content("Test Prep Credit")
    expect(page).to have_content(client.test_prep_credit)
    expect(page).to have_content("Action")
    expect(page).to have_content("Adjust Rates and Balances")
  end
end
