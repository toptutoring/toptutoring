require 'spec_helper'
require "rails_helper"

feature "Director client index" do
  let!(:client) { FactoryBot.create(:client_user) }
  let(:director) { FactoryBot.create(:director_user) }

  scenario "when director visits index page" do
    sign_in(director)

    visit director_clients_path

    expect(page).to have_content("Name")
    expect(page).to have_content(client.full_name)
    expect(page).to have_content(client.email)
    expect(page).to have_content("Academic Rate/Credit (O/I)")
    expect(page).to have_content(client.online_academic_rate)
    expect(page).to have_content(client.in_person_academic_rate)
    expect(page).to have_content(client.online_academic_credit)
    expect(page).to have_content(client.in_person_academic_credit)
    expect(page).to have_content("Test Prep Rate/Credit (O/I)")
    expect(page).to have_content(client.online_test_prep_rate)
    expect(page).to have_content(client.in_person_test_prep_rate)
    expect(page).to have_content(client.online_test_prep_credit)
    expect(page).to have_content(client.in_person_test_prep_credit)
    expect(page).to have_content("Action")
    expect(page).to have_link("edit_user_link_#{client.id}")
    expect(page).to have_link("archive_user_link_#{client.id}")
  end
end
